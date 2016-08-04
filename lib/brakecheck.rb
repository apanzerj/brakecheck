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

  def assert_latest(gem_name, version)
    assert version.to_s == Core.latest(gem_name).to_s, "#{gem_name} expected to be #{Core.latest(gem_name)} but was #{version}"
  end

  def expect_latest(gem_name, version)
    expect(version.to_s).to eq(Core.latest(gem_name).to_s)
  end

  def loaded_specs(gem_name)
    gem_here = Gem.loaded_specs[gem_name]
    gem_here.nil? ? :not_in_bundle : gem_here.version.to_s
  end
end
