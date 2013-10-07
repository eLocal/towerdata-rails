# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tower_data/version'

Gem::Specification.new do |spec|
  spec.name          = "towerdata-rails"
  spec.version       = Towerdata::Rails::VERSION
  spec.authors       = ["Andrew Fallows"]
  spec.email         = ["andrew.fallows@elocal.com"]
  spec.description   = %q{Provides methods for invoking the TowerData REST API, as well as ActiveModel validators which use TowerData to verify email address and phone number}
  spec.summary       = %q{Ruby wrapper for TowerData API}
  spec.homepage      = "www.elocal.com"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "vcr"
  spec.add_development_dependency "rspec"
end
