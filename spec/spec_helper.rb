require 'rubygems'
require 'bundler/setup'
require 'rails_kvs_driver'

RSpec.configure do |config|
  config.mock_framework = :rspec
  config.before(:each) {
    RailsKvsDriver::KVS_CONNECTION_POOL.clear

    # mock config
    @driver_config = {
        :host           => 'localhost', # host of KVS.
        :port           => 6379,        # port of KVS.
        :namespace      => 'Example',   # namespace of avoid a conflict with key
        :timeout_sec    => 5,           # timeout seconds.
        :pool_size      => 5,           # connection pool size.
    }
  }
end

# mock driver class
class MockDriver < RailsKvsDriver::Base
  def self.connect(args)
    'dummy1'
  end
end

class MockDriver2 < MockDriver
  def self.connect(args)
    'dummy2'
  end
end