# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'buho/version'

Gem::Specification.new do |gem|
  gem.name          = 'buho'
  gem.version       = Buho::VERSION
  gem.author        = 'Diego Saint Esteben'
  gem.email         = 'diego@saintesteben.me'
  gem.description   = %q{HAML Watcher like SASS or CoffeeScript}
  gem.summary       = %q{HAML Watcher like SASS or CoffeeScript}
  gem.homepage      = 'http://github.com/dosten/buho'

  gem.files         = Dir['lib/*.rb'] + Dir['lib/*/*.rb']
  gem.files        += `git ls-files`.split($/)
  gem.executables   = ['buho']
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_dependency "haml"
  gem.add_dependency "wdm"
  gem.add_dependency "listen"
end

