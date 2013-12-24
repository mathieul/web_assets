# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dynamo_assets/version'

Gem::Specification.new do |spec|
  spec.name          = "dynamo_assets"
  spec.version       = DynamoAssets::VERSION
  spec.authors       = ["Mathieu Lajugie"]
  spec.email         = ["mathieul@gmail.com"]
  spec.description   = %q{Asset pipeline CLI to be executed from a different language.}
  spec.summary       = spec.description
  spec.homepage      = "https://github.com/mathieul/dynamo_assets"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "compass", "~> 0.12.2"
  spec.add_dependency "sprockets", "~> 2.10.0"
  spec.add_dependency "erlectricity", "~> 1.1.1"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
