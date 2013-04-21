# coding: utf-8
$:.push File.expand_path('../lib', __FILE__)

require 'fyro-backer/version'

Gem::Specification.new do |spec|
  spec.name          = 'fyro-backer'
  spec.version       = Fyro::Backer::VERSION
  spec.authors       = ['Michael Shi']
  spec.email         = ['michael@shi.co.nz']
  spec.description   = %q{FyroBacker is a simple PostgreSQL backup utility}
  spec.summary       = %q{FyroBacker is a simple PostgreSQL backup utility}
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']
  
  spec.add_dependency 'thor', '~> 0.18.1'
  spec.add_dependency 'active_support', '~> 3.0.0'
  spec.add_dependency 'rubyzip', '~> 0.9.9'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'debugger'
  spec.add_development_dependency 'fakefs', '~> 0.4.2'
  spec.add_development_dependency 'timecop', '~> 0.6.1'
end
