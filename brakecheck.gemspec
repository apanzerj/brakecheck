# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'brakecheck/version'

Gem::Specification.new do |spec|
  spec.name          = "brakecheck"
  spec.version       = Brakecheck::VERSION
  spec.authors       = ["Adam Panzer"]
  spec.email         = ["apanzer@zendesk.com"]

  spec.summary       = %q{Enforce gemfile dependencies by breaking stuff.}
  spec.description   = %q{Make sure that your brakeman gem (or other gem) is always on the latest version.}
  spec.homepage      = "https://github.com/apanzerj/brakecheck"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "bin"
  spec.executables   = ['brakecheck']
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_runtime_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "webmock"
  spec.add_development_dependency "pry"
  spec.add_runtime_dependency "minitest"
  spec.add_runtime_dependency "faraday"
  spec.add_runtime_dependency "faraday_middleware"
end
