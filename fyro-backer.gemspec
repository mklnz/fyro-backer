# coding: utf-8
$:.push File.expand_path('../lib', __FILE__)

require 'fyro-backer/version'

Gem::Specification.new do |spec|
  spec.name          = 'fyro-backer'
  spec.version       = Fyro::Backer::VERSION
  spec.authors       = ['Michael Shi']
  spec.email         = ['michael@shi.co.nz']
  spec.description   = %q{TODO: Write a gem description}
  spec.summary       = %q{TODO: Write a gem summary}
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']
  
  spec.add_dependency 'net-sftp', '~> 2.1.1'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
end
