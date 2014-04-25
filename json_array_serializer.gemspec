# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'json_array_serializer/version'

Gem::Specification.new do |spec|
  spec.name          = "json_array_serializer"
  spec.version       = JSONArraySerializer::VERSION
  spec.authors       = ["Nathan Lilienthal"]
  spec.email         = ["nathan@nixpulvis.com"]
  spec.summary       = %q{Simple serialization for arrays of things to arrays of JSON.}
  spec.description   = %q{Provides an common interface to convert between arrays of objects that implement .new and #to_h methods to arrays of JSON.}
  spec.homepage      = "https://github.com/Americastestkitchen/json_array_serializer"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake", "~> 10.3"
  spec.add_development_dependency "rspec", "~> 2.14"
end
