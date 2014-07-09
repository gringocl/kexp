# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'kexp/version'

Gem::Specification.new do |spec|
  spec.name          = "kexp"
  spec.version       = Kexp::VERSION
  spec.authors       = ["Miles Starkenburg"]
  spec.email         = ["milesstarkenburg@gmail.com"]
  spec.summary       = %q{KEXP music discovery}
  spec.description   = %q{Explore and analzye weather's impact on kexp's music selection}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "fakeweb", ["~> 1.3"]
  spec.add_development_dependency "echowrap"
  spec.add_development_dependency "nokogiri"
  spec.add_development_dependency "mongo"
end

