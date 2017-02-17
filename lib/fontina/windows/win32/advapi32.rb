module Fontina::Windows::Win32

  dlload :Advapi32 do
    extern 'long RegOpenKeyExW(PVOID, LPCSTR, DWORD, DWORD, PVOID*)' \
      do |hkey, subkey, sam, options: 0|
        result = pvoid(NULL)
        Error.check super(hkey, wstr(subkey), options, sam, result)
        result.to_i
      end

    extern 'long RegCloseKey(PVOID)' \
      do |*_|
        Error.check super(*_)
      end

    extern 'long RegQueryInfoKeyW(PVOID, LPSTR, DWORD*, DWORD*, DWORD*, DWORD*, DWORD*, DWORD*, DWORD*, DWORD*, DWORD*, DWORD64*)' \
      do |hkey|
        subkey_count = dword(NULL)
        max_subkey_len = dword(NULL)
        value_count = dword(NULL)
        max_name_len = dword(NULL)
        max_data_len = dword(NULL)
        Error.check super(hkey, NULL, NULL, NULL, subkey_count, max_subkey_len, NULL, value_count, max_name_len, max_data_len, NULL, NULL)
        const_get(:RegQueryInfoKeyResult)[
          subkey_count.to_i, max_subkey_len.to_i, value_count.to_i, max_name_len.to_i, max_data_len.to_i
        ]
      end

    const_set :RegQueryInfoKeyResult, Mores::ImmutableStruct.new(
      *%i[subkey_count max_subkey_len value_count max_name_len max_data_len],
      strict: true
    )

    extern 'long RegEnumValueW(PVOID, DWORD, LPSTR, DWORD*, DWORD*, DWORD*, BYTE*, DWORD*)' \
      do |hkey, index, name_len: 16383, data_len: nil|
        name, name_len = wchar(0) * name_len, dword(name_len)
        type = dword(NULL)
        data, data_len = data_len ? [byte(0) * data_len, dword(data_len)] : [NULL, dword(NULL)]
        Error.check super(hkey, index, name, name_len, NULL, type, data, data_len)
        const_get(:RegEnumValueResult)[
          name[0, name_len.to_i], type.to_i, (data[0, data_len.to_i] unless NULL == data), data_len.to_i
        ]
      end

    const_set :RegEnumValueResult, Mores::ImmutableStruct.new(
      *%i[name type data data_len],
      strict: true
    )

    extern 'long RegGetValueW(PVOID, LPCSTR, LPCSTR, DWORD, DWORD*, BYTE*, DWORD*)' \
      do |hkey, subkey, name, flags: RRF_RT_ANY, data_len: nil|
        type = dword(NULL)
        data, data_len = data_len ? [byte(0) * data_len, dword(data_len)] : [NULL, dword(NULL)]
        Error.check super(hkey, wstr(subkey), wstr(name), flags, type, data, data_len)
        const_get(:RegGetValueResult)[
          type.to_i, (data[0, data_len.to_i] unless NULL == data), data_len.to_i
        ]
      end

    const_set :RegGetValueResult, Mores::ImmutableStruct.new(
      *%i[type data data_len],
      strict: true
    )

    extern 'long RegSetValueExW(PVOID, LPCSTR, DWORD, DWORD, BYTE*, DWORD)' \
      do |hkey, name, type, data|
        data_len = data ? data.bytesize : 0
        Error.check super(hkey, wstr(name), 0, type, data, data_len)
      end
  end

end
