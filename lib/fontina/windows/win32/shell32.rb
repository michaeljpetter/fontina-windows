module Fontina::Windows::Win32

  dlload :Shell32 do
    extern 'long SHGetFolderPathW(HWND, int, HANDLE, DWORD, LPSTR)' \
      do |folder, token: NULL, flags: SHGFP_TYPE_CURRENT|
        path = wchar(0) * MAX_PATH
        Error.check_hr super(NULL, folder, token, flags, path)
        path.rstrip
      end
  end

end
