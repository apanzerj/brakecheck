require 'spec_helper'

describe Brakecheck do
  include Brakecheck

  describe 'when the gem is in the current bundle' do
    before do
      stub_request(:get, "https://rubygems.org/api/v1/versions/foo/latest.json").
        to_return(status: 200, body: %q{{"version": "1.0.0"}}, headers: {'Content-Type' => 'application/json'})
      version = double(:version)
      expect(version).to receive(:version).and_return('1.0.0')
      expect(Gem).to receive(:loaded_specs).and_return({'foo' => version})
    end

    it 'passes' do
      expect_latest('foo', loaded_specs('foo'))
    end
  end
end
