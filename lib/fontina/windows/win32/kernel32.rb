module Fontina::Windows::Win32

  dlload :Kernel32 do
    extern 'DWORD GetLastError()'
    extern 'void SetLastError(DWORD)'

    extern 'DWORD FormatMessageW(DWORD, PVOID, DWORD, DWORD, LPSTR, DWORD, PVOID)' \
      do |flags, message_id, len, source: NULL, language_id: 0|
        flags |= FORMAT_MESSAGE_IGNORE_INSERTS
        buffer = wchar(0) * len
        len = super(flags, source, message_id, language_id, buffer, len, NULL)
        Error.raise_last if 0 == len
        buffer[0, len]
      end

    extern 'WORD GetSystemDefaultUILanguage()'
  end

end
