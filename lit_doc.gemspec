# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'lit_doc/version'

Gem::Specification.new do |spec|
  spec.name          = "lit_doc"
  spec.version       = LitDoc::VERSION
  spec.authors       = ["Humoud"]
  spec.email         = ["humoud.m.alsaleh@gmail.com"]

  spec.summary       = "Makes documenting Rails APIs swift and easy."
  spec.description   = "Used to generate markdown docs for Rails API projects"
  spec.homepage      = "https://github.com/Humoud/lit_doc"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "activesupport", "~> 5.1"
end
