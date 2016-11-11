$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'brakecheck'
require 'webmock/rspec'

WebMock.disable_net_connect!(allow: 'rubygems.org')
