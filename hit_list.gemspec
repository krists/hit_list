# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hit_list/version'

Gem::Specification.new do |spec|
  spec.name          = "hit_list"
  spec.version       = HitList::VERSION
  spec.authors       = ["Krists Ozols"]
  spec.email         = ["krists.ozols@gmail.com"]
  spec.description   = %q{Very simple and fast hit and popularity counter using Redis sorted sets.}
  spec.summary       = %q{It solves problem where you need to know most popular article or project in last X days.}
  spec.homepage      = "https://github.com/krists/hit_list"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency 'timecop'
  spec.add_development_dependency "fakeredis"

end
