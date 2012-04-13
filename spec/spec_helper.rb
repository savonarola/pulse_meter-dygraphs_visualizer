require 'rubygems'
require 'bundler/setup'
$:.unshift File.expand_path('../../lib/', __FILE__)

ROOT = File.expand_path('../..', __FILE__)

require 'pulse-meter'

Bundler.require(:default, :test, :development)

Dir['spec/support/**/*.rb'].each{|f| require File.join(ROOT, f) }
Dir['spec/shared_examples/**/*.rb'].each{|f| require File.join(ROOT,f)}

RSpec.configure do |config|
  config.before(:each) { PulseMeter.redis = MockRedis.new }

end

