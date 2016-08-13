require 'spec_helper'

describe Brakecheck do
  include Brakecheck

  let(:version) { "3.3.0" }
  let(:spec1) { double(:spec1, name: "brakeman", version: version) }
  let(:spec2) { double(:spec2, name: "bar", version: "1.1.0") }
  let(:specs) { [ spec1, spec2 ] }
  let(:load_spec) { double(:foo) }

  before do
    stub_gem_request("brakeman", "1.1.0")
    stub_gem_request("foo", "1.1.0")
    expect(Bundler).to receive(:load).and_return(load_spec)
    expect(load_spec).to receive(:specs).and_return(specs)
  end

  describe 'when the gem is in the current bundle' do
    let(:version) { "1.1.0" }

    it 'passes' do
      expect_latest 'brakeman'
    end
  end

  describe 'when the gem is not in the current bundle' do
    it 'fails' do
      expect{ expect_latest('foo') }.to raise_error(RSpec::Expectations::ExpectationNotMetError)
    end

    it 'says it is not in the bundle' do
      expect(loaded_specs('foo')).to eq(:not_in_bundle)
    end
  end

  describe 'when we have the wrong version' do
    let(:version) { '0.0.9' }

    it 'fails' do
      expect{ expect_latest('brakeman') }.to raise_error(RSpec::Expectations::ExpectationNotMetError)
    end
  end

  describe 'rspec_matcher' do
    describe 'when it is the latest version' do
      let(:version) { "1.1.0" }

      it{ expect('brakeman').to be_the_latest_version }
    end

    describe 'not the latest version' do
      let(:version) { "0.9.0" }

      it 'raises an error' do
        expect{ expect('brakeman').to be_the_latest_version }.to raise_error(RSpec::Expectations::ExpectationNotMetError)
      end
    end
  end
end
