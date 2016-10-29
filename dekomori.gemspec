# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dekomori/version'

Gem::Specification.new do |spec|
  spec.name          = "dekomori"
  spec.version       = Dekomori::VERSION
  spec.authors       = ["Adrien Katsuya Tateno"]
  spec.email         = ["adrien.k.tateno@gmail.com"]

  spec.summary       = %q{dekomori decorates methods}
  spec.homepage      = "https://github.com/katsuya94/dekomori"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^spec/})
  end
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry-byebug", "~> 3.4.0"
end
