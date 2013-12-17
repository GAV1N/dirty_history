# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dirty_history/version'

Gem::Specification.new do |spec|
  spec.name          = "dirty_history"
  spec.version       = DirtyHistory::VERSION
  spec.authors       = ["Gavin Todes"]
  spec.email         = ["gavin.todes@gmail.com"]
  spec.summary       = "Easily keep track of changes to specific model fields."
  spec.description   = "Dirty History is a simple gem that allows you to keep track of changes to specific fields in your Rails models using the ActiveRecord::Dirty module."
  spec.homepage      = "http://github.com/GAV1N/dirty_history"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
