module Fontina
  module Windows

    module MetaPackage
      include Marshal
      Fontina::MetaPackage.include self

      using Mores::Patch::FileUtils

      def registered_name
        @registered_name ||= begin
          name = package.preferred_name \
            ? wstr(package.preferred_name.name)
            : package.fonts.map { |f| wstr(f.preferred_name.name) }.join(wstr(' & '))

          [Formats::OpenType].include?(format) \
            ? name + wstr(' (TrueType)')
            : name
        end
      end

      def installed?
        !!(path = Windows.font_registered? registered_name) and
        path = File.expand_path(path, Windows.fonts_directory) and
        File.file?(path) and
        File.open(path) { |io| FileUtils.compare_stream io.binmode, StringIO.new(file.content) }
      end

      def install(force: false)
        return if installed? unless force

        add_times = 1
        path = Windows.font_registered? registered_name

        Dir.chdir(Windows.fonts_directory) do
          add_times = Windows.remove_font_resource path if path and File.exist? path
          path, = FileUtils.safe_write file.filename, file.content
        end

        Windows.add_font_resource(path, times: add_times).tap do |count|
          unless count == package.fonts.length
            fail "Windows reported #{count} fonts added (expected: #{package.fonts.length})"
          end
        end

        Windows.register_font registered_name, path
        Windows.notify_fonts_changed
      end
    end

  end
end
