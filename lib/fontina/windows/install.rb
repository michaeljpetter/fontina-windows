module Fontina::Windows::Install
  Fontina.extend self

  def install(location)
    open(location).install
  end

end
