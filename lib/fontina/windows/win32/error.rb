module Fontina::Windows::Win32

  class Error < StandardError
    attr_reader :code

    def initialize(code)
      @code = code
    end

    def to_s
      @message ||= begin
        Kernel32.FormatMessageW(FORMAT_MESSAGE_FROM_SYSTEM, code, 1024).rstrip
      rescue Error
        '0x%04x' % code
      end
    end

    class << self
      def raise_last
        raise new Kernel32.GetLastError()
      end

      def check_last
        check Kernel32.GetLastError()
      end

      def check(code)
        raise new code unless ERROR_SUCCESS == code
      end

      def check_hr(code)
        raise new code unless 0 == code[31]
      end

      def clear
        Kernel32.SetLastError(ERROR_SUCCESS)
      end
    end
  end

end
