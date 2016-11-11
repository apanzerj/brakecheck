require "brakecheck"
RSpec.describe ENV['BRAKECHECK_GEM'] do
  before do
    WebMock.disable_net_connect!(allow: 'rubygems.org') if defined? WebMock
  end

  it 'is the lastest version' do
    expect(ENV['BRAKECHECK_GEM']).to be_the_latest_version
  end
end
