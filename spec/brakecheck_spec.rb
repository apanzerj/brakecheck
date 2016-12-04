require "spec_helper"

describe Brakecheck::Core do
  describe ".compare" do
    before do
      content = File.read('Gemfile.lock')
      expect(Bundler).to receive(:read_file).and_return(content)
    end

    it "passes when on the latest version" do
      stub_request(:get, "https://rubygems.org/api/v1/versions/rake/latest.json").
        to_return(body: '"{"version":"10.5.0"}"')
      expect(Brakecheck::Core.compare("rake")).to eq([true, "Latest rake 10.5.0 installed"])
    end

    it "fails when not on the latest version" do
      stub_request(:get, "https://rubygems.org/api/v1/versions/rake/latest.json").
        to_return(body: '"{"version":"10.6.0"}"')
      expect(Brakecheck::Core.compare("rake")).to eq([false, "Local version 10.5.0 of rake is not the latest version 10.6.0"])
    end

    it "fails when gem is not in the bundle" do
      expect(Brakecheck::Core.compare("foo")).to eq([false, "foo not found in Gemfile.lock"])
    end

    it "fails when gem is not on rubygems" do
      stub_request(:get, "https://rubygems.org/api/v1/versions/rake/latest.json").
        to_return(status: 404)
      expect(Brakecheck::Core.compare("rake")).to eq([false, "rake not found on https://rubygems.org"])
    end
  end
end