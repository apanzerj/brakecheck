require 'spec_helper'

describe Brakecheck do
  include Brakecheck

  before do
    allow(Bundler).to receive(:default_lockfile).at_least(1).times
      .and_return(File.join(Bundler.root, "spec", "test_gem.lock"))
  end

  describe 'when the gem is current and in the bundle' do
    it 'passes' do
      expect('footing').to be_the_latest_version
    end
  end

  describe 'when the gem is not in the current bundle' do
    subject{ expect('darkside').to be_the_latest_version }

    it 'fails' do
      expect{ subject }.to raise_error(RSpec::Expectations::ExpectationNotMetError)
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
end
