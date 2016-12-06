require "brakecheck/version"
require "open-uri"
require "bundler"

module Brakecheck
  class Core
    RUBYGEMS_HOST = "https://rubygems.org"
    LOCK = Bundler.default_lockfile

    def self.latest(gem_name)
      open("#{RUBYGEMS_HOST}/api/v1/versions/#{gem_name}/latest.json").read[/"version":"(.+?)"/, 1]
    rescue StandardError
      nil
    end

    def self.local(gem_name)
      lock = Bundler::LockfileParser.new(Bundler.read_file(LOCK))
      return unless spec = lock.specs.detect { |s| s.name == gem_name }
      spec.version.to_s
    end

    def self.compare(gem_name)
      return [false, "#{gem_name} not found in #{LOCK.basename}"] unless local = local(gem_name)
      return [false, "#{gem_name} not found on #{RUBYGEMS_HOST}"] unless latest = latest(gem_name)

      if latest == local
        [true, "Latest #{gem_name} #{latest} installed"]
      else
        [false, "Local version #{local} of #{gem_name} is not the latest version #{latest}"]
      end
    end
  end
end
