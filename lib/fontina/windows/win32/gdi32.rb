module Fontina::Windows::Win32

  dlload :Gdi32 do
    extern 'int AddFontResourceW(LPCSTR)' \
      do |filename|
        count = super(wstr filename)
        Error.check_last if 0 == count
        count
      end

    extern 'BOOL RemoveFontResourceW(LPCSTR)' \
      do |filename|
        Error.clear
        success = 0 != super(wstr filename)
        Error.check_last unless success
        success
      end
  end

end
