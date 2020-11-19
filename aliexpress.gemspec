# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'aliexpress/version'

Gem::Specification.new do |spec|
  spec.name          = 'aliexpress'
  spec.version       = Aliexpress::VERSION
  spec.authors       = ['Denis Sobolev']
  spec.email         = ['dns.sobol@gmail.com']

  spec.summary       = 'Aliexpress Portal Ruby SDK'
  spec.description   = 'Aliexpress Portal Ruby SDK'
  spec.homepage      = 'https://github.com/umount/aliexpress'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'rest-client', '~> 2.0'
  spec.add_dependency('activesupport', '~> 5.0')

  spec.add_development_dependency 'bundler', '~> 1.11'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
