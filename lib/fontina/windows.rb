%w[
  fontina
  fontina/windows/language_codes
  fiddle
  fiddle/import
  fiddle/types
].each { |lib| require lib }

%w[
  version
  marshal
  win32
  package
  meta_package
  install
].each { |file| require_relative "windows/#{file}" }

module Fontina::Windows
  include Win32
  extend Marshal

  def self.system_language
    @system_language ||= LANGUAGE_CODES.fetch Kernel32.GetSystemDefaultUILanguage()
  end

  def self.fonts_directory
    @fonts_directory ||= Shell32.SHGetFolderPathW(CSIDL_FONTS).encode('filesystem').freeze
  end

  def self.registered_fonts
    key = Advapi32.RegOpenKeyExW(HKEY_LOCAL_MACHINE, 'SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts', KEY_READ)
    begin
      Advapi32.RegQueryInfoKeyW(key)
        .tap do |info|
          break info.value_count.times.map do |i|
            Advapi32.RegEnumValueW(key, i, name_len: info.max_name_len + 1, data_len: info.max_data_len)
          end
        end
        .reject { |value| value.type != REG_SZ }
        .map { |value| [value.name, wstr!(value.data).rstrip.encode('filesystem')] }
        .to_h
    ensure
      Advapi32.RegCloseKey(key)
    end
  end

  def self.add_font_resource(path)
    Gdi32.AddFontResourceW(path).tap do |count|
      User32.PostMessageW(HWND_BROADCAST, WM_FONTCHANGE, 0, 0) if 0 < count
    end
  end

  def self.register_font(name, path)
    key = Advapi32.RegOpenKeyExW(HKEY_LOCAL_MACHINE, 'SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts', KEY_WRITE)
    begin
      Advapi32.RegSetValueExW(key, name, REG_SZ, wstr(path) + wchar(0))
    ensure
      Advapi32.RegCloseKey(key)
    end
  end

end
