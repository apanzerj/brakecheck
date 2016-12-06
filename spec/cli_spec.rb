require 'spec_helper'

describe 'CLI' do
  def sh(command, fail: false)
    result = `#{command} 2>&1`
    raise "FAIL: #{result}" if $?.success? == fail
    result
  end

  it "passes when the gem is current and in the bundle" do
    expect(sh("brakecheck webmock")).to eq("Latest webmock 2.3.0 installed\n")
  end

  it "fails when the gem is not found in Gemfile.lock" do
    expect(sh("brakecheck foo", fail: true)).to eq("foo not found in Gemfile.lock\n")
  end

  it "fails when no gem name was given" do
    expect(sh("brakecheck", fail: true)).to eq("Need gem name as only argument\n")
  end
end
