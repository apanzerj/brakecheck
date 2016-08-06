require 'spec_helper'

describe Brakecheck do
  include Brakecheck
  let(:version_string) { "1.0.0" }
  let(:version) do
    version = double(:version)
    allow(version).to receive(:version).and_return(version_string)
    version
  end

  before do
    stub_request(:get, "https://rubygems.org/api/v1/versions/foo/latest.json").
      to_return(status: 200, body: %q{{"version": "1.0.0"}}, headers: {'Content-Type' => 'application/json'})
    stub_request(:get, "https://rubygems.org/api/v1/versions/bar/latest.json").
      to_return(status: 200, body: %q{{"version": "1.1.0"}}, headers: {'Content-Type' => 'application/json'})

    expect(Gem).to receive(:loaded_specs).and_return({'foo' => version})
  end

  describe 'when the gem is in the current bundle' do
    it 'passes' do
      expect_latest 'foo'
    end
  end

  describe 'when the gem is not in the current bundle' do
    it 'fails' do
      expect{ expect_latest('bar') }.to raise_error(RSpec::Expectations::ExpectationNotMetError)
    end

    it 'says it is not in the bundle' do
      expect(loaded_specs('bar')).to eq(:not_in_bundle)
    end
  end

  describe 'when we have the wrong version' do
    let(:version_string) { '0.0.9' }

    it 'fails' do
      expect{ expect_latest('foo') }.to raise_error(RSpec::Expectations::ExpectationNotMetError)
    end
  end
end
