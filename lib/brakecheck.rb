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
        Brakecheck::Core.latest(gem_name) == loaded_specs(gem_name)
      end
    end
  end

  def assert_latest(gem_name)
    version = loaded_specs(gem_name)
    assert version == Core.latest(gem_name).to_s, "#{gem_name} expected to be #{Core.latest(gem_name)} but was #{version}"
  end

  def expect_latest(gem_name)
    expect(loaded_specs(gem_name)).to eq(Core.latest(gem_name).to_s)
  end

  def loaded_specs(gem_name)
    gem_here = Bundler.load.specs.detect do |specs|
      specs.name == gem_name
    end
    gem_here.nil? ? :not_in_bundle : gem_here.version.to_s
  end
end
