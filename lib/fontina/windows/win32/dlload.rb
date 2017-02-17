module Fontina::Windows

  module Win32
    def self.dlload(name)
      const_set(name, Module.new do
        extend Importer
        dlload "#{name}.dll"
        include Fiddle::Win32Types

        instance_eval &Proc.new if block_given?
      end)
    end

    module Importer
      include Fiddle::Importer
      include Marshal

      def extern(*)
        super.tap { |fn| decorators.send(:define_method, fn.name, &Proc.new) if block_given? }
      end

      private

      def decorators
        @decorators ||= Module.new.tap { |m| singleton_class.prepend m }
      end
    end
  end

end
