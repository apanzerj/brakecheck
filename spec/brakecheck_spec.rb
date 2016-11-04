require 'spec_helper'
require 'minitest/autorun'

describe Brakecheck do
  include Brakecheck

  before do
    expect(Bundler).to receive(:default_lockfile).and_return(File.join(Bundler.root, "spec", "test_gem.lock"))
    stub_gem_request("footing", "1.0.2") # up to date
    stub_gem_request("brakeman", "3.0.0") # outdated spec
  end

  describe 'when the gem is current and in the bundle' do
    it 'passes' do
      expect('footing').to be_the_latest_version
    end
  end

  describe 'when the gem is not in the current bundle' do
    it 'fails' do
      expect{ expect('darkside').to be_the_latest_version }.to raise_error(RSpec::Expectations::ExpectationNotMetError)
    end

    it 'says it is not in the bundle' do
      expect(loaded_specs('darkside')).to match(:not_in_bundle)
    end
  end

  describe 'when we have the wrong version' do
    it 'fails' do
      expect{ expect('brakeman').to be_the_latest_version }.to raise_error(RSpec::Expectations::ExpectationNotMetError)
    end
  end

  describe 'rspec_matcher' do
    describe 'when it is the latest version' do
      it{ expect('footing').to be_the_latest_version }
    end

    describe 'not the latest version' do
      it 'raises an error' do
        expect{ expect('brakeman').to be_the_latest_version }.to raise_error(RSpec::Expectations::ExpectationNotMetError)
      end
    end
  end

  describe 'minitest' do
    it 'foo' do
      "brakeman".must_be_latest_version
    end
  end
end
