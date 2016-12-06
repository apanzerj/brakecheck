require 'brakecheck'
require 'rspec/expectations'

module Brakecheck
  module RSpec
    ::RSpec::Matchers.define :be_the_latest_version do
      match do |gem_name|
        success, @message = Brakecheck::Core.compare(gem_name)
        success
      end

      failure_message do |_gem_name|
        @message
      end
    end
  end
end