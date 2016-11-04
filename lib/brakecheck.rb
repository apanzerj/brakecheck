require "brakecheck/version"
require "faraday"
require "faraday_middleware"

module Brakecheck
  class Core
    attr_reader :client

    def self.latest(gem_name)
      new.client.get("#{gem_name}/latest.json").body['version']
    end

    def client
      @client = Faraday.new(:url => "https://rubygems.org/api/v1/versions") do |faraday|
        faraday.request       :url_encoded
        faraday.adapter       Faraday.default_adapter
        faraday.use           FaradayMiddleware::ParseJson
      end
    end
  end

  module Rspec
    require 'rspec/expectations'

    RSpec::Matchers.define :be_the_latest_version do
      match do |gem_name|
        spec_from_file = loaded_specs(gem_name)
        if spec_from_file == :not_in_bundle
          return false
        else
          Brakecheck::Core.latest(gem_name) == loaded_specs(gem_name)
        end
      end

      failure_message do |actual|
        if actual == :not_in_bundle
          "that gem is not in the bundle"
        else
          "expected gem to be #{expected} but was actually #{actual}."
        end
      end
    end

    def loaded_specs(gem_name)
      gem_here = specs.detect do |specs|
        specs.name == gem_name
      end

      gem_here.nil? ? :not_in_bundle : gem_here.version.to_s
    end

    def specs
      @specs ||= Bundler::LockfileParser.new(Bundler.read_file(Bundler.default_lockfile)).specs
    end
  end
end
