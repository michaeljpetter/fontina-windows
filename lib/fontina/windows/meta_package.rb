module Fontina
  module Windows

    module MetaPackage
      include Marshal
      Fontina::MetaPackage.include self

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

      def install
        conflicts = Windows.registered_fonts
          .find_all { |(name, path)| (name == registered_name) ^ (path == file.filename) }
        fail "Conflicting registrations found: #{conflicts.to_h}" unless conflicts.empty?

        File.write File.join(Windows.fonts_directory, file.filename), file.content

        unless (count = Windows.add_font_resource file.filename) == package.fonts.length
          fail "Windows reported #{count} fonts added (expected: #{package.fonts.length})"
        end

        Windows.register_font registered_name, file.filename
      end
    end

  end
end
