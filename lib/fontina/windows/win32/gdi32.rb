module Fontina::Windows::Win32

  dlload :Gdi32 do
    extern 'int AddFontResourceW(LPCSTR)' \
      do |filename|
        count = super(wstr filename)
        Error.check_last if 0 == count
        count
      end
  end

end
