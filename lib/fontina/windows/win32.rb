%w[
  constants
  dlload
  error
  kernel32
  user32
  shell32
  gdi32
  advapi32
].each { |file| require_relative "win32/#{file}" }

module Fontina::Windows

  module Win32
    private_constant *constants
  end
  private_constant :Win32

end
