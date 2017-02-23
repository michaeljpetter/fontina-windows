require_relative 'lib/fontina/windows/version'

Gem::Specification.new do |gem|
  gem.name          = 'fontina-windows'
  gem.version       = Fontina::Windows::VERSION
  gem.author        = 'Michael Petter'
  gem.email         = 'michaeljpetter@gmail.com'

  gem.summary       = 'A cheesy windows font extension'
  gem.description   = <<-END
    Installs font files in Windows.
  END
  gem.homepage      = 'http://github.com/michaeljpetter/fontina-windows'
  gem.license       = 'MIT'

  gem.platform      = Gem::Platform::RUBY
  gem.files         = Dir.glob %w(lib/**/* Gemfile *.gemspec LICENSE* README*)
  gem.require_paths = ['lib']

  gem.add_dependency 'fontina', '>= 0.2.1'
  gem.add_dependency 'mores', '>= 0.3.2'

  gem.add_development_dependency 'bundler', '~> 1.7'
  gem.add_development_dependency 'rake', '~> 10.0'
  gem.add_development_dependency 'rspec', '~> 3.4'
  gem.add_development_dependency 'rspec-its', '~> 1.2'
end
