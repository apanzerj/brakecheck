require 'spec_helper'

describe Brakecheck::RSpec do
  include Brakecheck::RSpec

  before do
    content = File.read('Gemfile.lock')
    expect(Bundler).to receive(:read_file).and_return(content)
  end

  it "passes when on the latest version" do
    stub_request(:get, "https://rubygems.org/api/v1/versions/rake/latest.json").
      to_return(body: '"{"version":"10.5.0"}"')
    expect("rake").to be_the_latest_version
  end

  it "fails when not on the latest version" do
    stub_request(:get, "https://rubygems.org/api/v1/versions/rake/latest.json").
      to_return(body: '"{"version":"10.6.0"}"')
    expect do
      expect("rake").to be_the_latest_version
    end.to raise_error(RSpec::Expectations::ExpectationNotMetError, "Local version 10.5.0 of rake is not the latest version 10.6.0")
  end
end
