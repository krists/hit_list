# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hot_or_not/version'

Gem::Specification.new do |spec|
  spec.name          = "hot_or_not"
  spec.version       = HotOrNot::VERSION
  spec.authors       = ["Krists Ozols"]
  spec.email         = ["krists@iesals.lv"]
  spec.description   = %q{Very simple and fast hit and popularity counter using Redis sorted sets.}
  spec.summary       = %q{
    Very simple and fast hit and popularity counter using Redis sorted sets.
    It solves problem where you need to know most popular article or project in last X days.
  }
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
