$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'brakecheck'
require 'webmock/rspec'

def stub_gem_request(name, version)
  stub_request(:get, "https://rubygems.org/api/v1/versions/#{name}/latest.json").
    to_return(status: 200, body: {"version": version}.to_json, headers: {'Content-Type' => 'application/json'})
end
