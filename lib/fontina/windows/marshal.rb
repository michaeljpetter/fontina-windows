module Fontina::Windows

  module Marshal
    BYTE = Encoding::BINARY
    WCHAR = Encoding::UTF_16LE

    private_constant *constants
    module_function

    define_method :dword, &(
      Class.new(String) do
        def initialize(i)
          super [i].pack('V')
        end
        def to_i
          unpack('V')[0]
        end
      end
    ).method(:new)

    alias_method :pvoid, :dword
    module_function :pvoid

    def byte(n)
      n.chr BYTE
    end

    def wchar(n)
      n.chr WCHAR
    end

    def wstr(s)
      s.encode WCHAR unless s.nil?
    end

    def wstr!(s)
      s.force_encoding WCHAR unless s.nil?
    end
  end
  private_constant :Marshal

end
