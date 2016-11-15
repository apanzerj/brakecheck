require "brakecheck/version"
require "faraday"
require "faraday_middleware"

module Brakecheck
  class Core
    attr_reader :client

    def self.latest(gem_name)
      new.client.get("#{gem_name}/latest.json").body['version']
    end

    def self.loaded_specs(gem_name)
      gem_here = specs.detect do |specs|
        specs.name == gem_name
      end

      gem_here.nil? ? :not_in_bundle : gem_here.version.to_s
    end

    def self.specs
      @specs ||= Bundler::LockfileParser.new(Bundler.read_file(Bundler.default_lockfile)).specs
    end

    def client
      @client = Faraday.new(:url => "https://rubygems.org/api/v1/versions") do |faraday|
        faraday.request       :url_encoded
        faraday.adapter       Faraday.default_adapter
        faraday.use           FaradayMiddleware::ParseJson
      end
    end
  end

  module TestUnit
    require 'test/unit/assertions'


    def assert_latest_version(gem_name, message = nil)
      message = build_message message, '<?> is not currently up to date.', gem_name
      assert_block message do
        assert_equal(Brakecheck::Core.latest(gem_name), Brakecheck::Core.loaded_specs(gem_name))
      end
    end
  end

  module Rspec
    require 'rspec/expectations'

    RSpec::Matchers.define :be_the_latest_version do
      match do |gem_name|
        spec_from_file = Brakecheck::Core.loaded_specs(gem_name)
        Brakecheck::Core.latest(gem_name) == spec_from_file
      end

      failure_message do |gem_name|
        if loaded_specs(gem_name) == :not_in_bundle
          "that gem is not in the bundle"
        else
          "expected #{gem_name} to be #{Brakecheck::Core.latest(gem_name)} but was actually #{loaded_specs(gem_name)}."
        end
      end
    end
  end
end

Test::Unit::TestCase.prepend(Brakecheck::TestUnit)
