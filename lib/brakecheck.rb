require "brakecheck/version"
require "bundler"

module Brakecheck
  RUBYGEMS_HOST = "https://rubygems.org"
  LOCK = Bundler.default_lockfile

  def self.latest(gem_name)
    Gem.latest_version_for(gem_name)
  end

  def self.local(gem_name)
    lock = Bundler::LockfileParser.new(Bundler.read_file(LOCK))
    return unless spec = lock.specs.detect { |s| s.name == gem_name }
    spec.version
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
