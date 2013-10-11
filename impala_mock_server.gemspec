# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'impala_mock_server/version'

Gem::Specification.new do |spec|
  spec.name          = "impala_mock_server"
  spec.version       = ImpalaMockServer::VERSION
  spec.authors       = ["Mitsunori Komatsu"]
  spec.email         = ["komamitsu@gmail.com"]
  spec.description   = %q{Impala Mock Server}
  spec.summary       = %q{Impala Mock Server}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "impala"
  spec.add_development_dependency "thin"
end
