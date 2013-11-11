require 'rspec'
require 'spec_helper'

describe RailsKvsDriver::Session do
  it 'defined KVS_CONNECTION_POOL' do
    expect(RailsKvsDriver.const_defined?(:KVS_CONNECTION_POOL)).to be_true
  end

  it 'The structure of RailsKvsDriver::KVS_CONNECTION_POOL is correct.' do
    MockDriver.session(@driver_config)  {}
    MockDriver2.session(@driver_config) {}
    MockDriver2.session(@driver_config.merge(a:0)) {}
    MockDriver2.session(@driver_config.merge(port:100)) {}

    expect(RailsKvsDriver::KVS_CONNECTION_POOL.length).to eq(2)
    expect(RailsKvsDriver::KVS_CONNECTION_POOL['MockDriver2'].length).to eq(2)
    expect(RailsKvsDriver::KVS_CONNECTION_POOL['MockDriver2'][0].length).to  eq(2)
    expect(RailsKvsDriver::KVS_CONNECTION_POOL['MockDriver2'][0].has_key? :config).to  be_true
    expect(RailsKvsDriver::KVS_CONNECTION_POOL['MockDriver2'][0].has_key? :pool).to    be_true
  end

  context 'call session' do
    it 'to hand over driver instance to the block' do
      MockDriver.session(@driver_config) do |instance|
        expect(instance.class).to eq(MockDriver)
        expect(instance.kvs_instance).to eq('dummy1')
      end

      MockDriver2.session(@driver_config) do |instance|
        expect(instance.class).to eq(MockDriver2)
        expect(instance.kvs_instance).to eq('dummy2')
      end
    end
  end
end