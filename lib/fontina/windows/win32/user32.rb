module Fontina::Windows::Win32

  dlload :User32 do
    extern 'BOOL PostMessageW(HWND, UINT, UINT, long)' \
      do |*_|
        Error.raise_last if 0 == super(*_)
      end
  end

end
