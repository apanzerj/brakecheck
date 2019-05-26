require './lib/brakecheck/version'

Gem::Specification.new do |spec|
  spec.name          = "brakecheck"
  spec.version       = Brakecheck::VERSION
  spec.authors       = ["Adam Panzer"]
  spec.email         = ["apanzer@zendesk.com"]

  spec.summary       = %q{Enforce gemfile dependencies by breaking stuff.}
  spec.description   = %q{Make sure that your brakeman gem (or other gem) is always on the latest version.}
  spec.homepage      = "https://github.com/apanzerj/brakecheck"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.executables   = ['brakecheck']

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "webmock"
  spec.add_development_dependency "pry"
end
