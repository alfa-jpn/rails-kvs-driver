require 'rspec'
require 'spec_helper'
require 'rails_kvs_driver'

describe RailsKvsDriver do

  before(:each) do
    @driver_config = {
        :host           => 'localhost', # host of KVS.
        :port           => 6379,        # port of KVS.
        :namespace      => 'Example',   # namespace of avoid a conflict with key
        :timeout_sec    => 5,           # timeout seconds.
        :pool_size      => 5,           # connection pool size.
    }

    class MockDriver < RailsKvsDriver::Base
      def connect
      end
    end

  end

  it 'raise NoMethodError when does not override connect' do
    expect{RailsKvsDriver::Base.new}.to raise_error
  end

  it 'raise NoMethodError when does not override []' do
    expect(MockDriver.method_defined?('[]')).to be_true
    expect{MockDriver.new['a']}.to raise_error
  end

  it 'raise NoMethodError when does not override []=' do
    expect(MockDriver.method_defined?('[]=')).to be_true
    expect{MockDriver.new['a']='b'}.to raise_error
  end

  it 'raise NoMethodError when does not override all_keys' do
    expect(MockDriver.method_defined?(:all_keys)).to be_true
    expect{MockDriver.new.all_keys}.to raise_error
  end

  it 'raise NoMethodError when does not override delete' do
    expect(MockDriver.method_defined?(:delete)).to be_true
    expect{MockDriver.new.delete}.to raise_error
  end

  it 'raise NoMethodError when does not override delete_all' do
    expect(MockDriver.method_defined?(:delete_all)).to be_true
    expect{MockDriver.new.delete_all}.to raise_error
  end

  it 'raise NoMethodError when does not override add_sorted_set' do
    expect(MockDriver.method_defined?(:add_sorted_set)).to be_true
    expect{MockDriver.new.add_sorted_set}.to raise_error
  end

  it 'raise NoMethodError when does not override remove_sorted_set' do
    expect(MockDriver.method_defined?(:remove_sorted_set)).to be_true
    expect{MockDriver.new.remove_sorted_set}.to raise_error
  end

  it 'raise NoMethodError when does not override increment_sorted_set' do
    expect(MockDriver.method_defined?(:increment_sorted_set)).to be_true
    expect{MockDriver.new.increment_sorted_set}.to raise_error
  end

  it 'raise NoMethodError when does not override sorted_set_score' do
    expect(MockDriver.method_defined?(:sorted_set_score)).to be_true
    expect{MockDriver.new.sorted_set_score}.to raise_error
  end

  it 'raise NoMethodError when does not override sorted_set' do
    expect(MockDriver.method_defined?(:sorted_set)).to be_true
    expect{MockDriver.new.sorted_set}.to raise_error
  end

  it 'raise NoMethodError when does not override count_sorted_set_member' do
    expect(MockDriver.method_defined?(:count_sorted_set_member)).to be_true
    expect{MockDriver.new.count_sorted_set_member}.to raise_error
  end

  context 'call initialize' do
    it 'exec validation' do
      expect{ MockDriver.new(@driver_config) }.not_to raise_error
    end

    it 'coping instance of driver_config' do
      expect(MockDriver.new(@driver_config).driver_config).to eq(@driver_config)
    end
  end

  context 'call validate_driver_config' do
    it 'raise ArgumentError when there is not host.' do
      @driver_config.delete(:host)
      expect{ MockDriver.new(@driver_config) }.to raise_error
    end

    it 'raise ArgumentError when there is not port.' do
      @driver_config.delete(:port)
      expect{ MockDriver.new(@driver_config) }.to raise_error
    end

    it 'raise ArgumentError when there is not namespace.' do
      @driver_config.delete(:namespace)
      expect{ MockDriver.new(@driver_config) }.to raise_error
    end

    it 'raise ArgumentError when there is not timeout_sec.' do
      @driver_config.delete(:timeout_sec)
      expect{ MockDriver.new(@driver_config) }.to raise_error
    end

    it 'raise ArgumentError when there is not pool_size.' do
      @driver_config.delete(:pool_size)
      expect{ MockDriver.new(@driver_config) }.to raise_error
    end
  end

  context 'call session' do
    before(:each) do
      class MockDriver2 < RailsKvsDriver::Base
        def connect
        end
      end
    end

    it 'DriverConnectionPool is same instance.' do
      expect(MockDriver::DriverConnectionPool.equal?(RailsKvsDriver::Base::DriverConnectionPool)).to be_true
    end

    it 'to hand over driver instance to the block' do
      MockDriver.session(@driver_config) do |instance|
        expect(instance.class).to eq(MockDriver)
      end

      MockDriver2.session(@driver_config) do |instance|
        expect(instance.class).to eq(MockDriver2)
      end
    end

    it 'The structure of DriverConnectionPool is correct.' do
      MockDriver.session(@driver_config)  {}
      MockDriver2.session(@driver_config) {}
      MockDriver2.session(@driver_config.merge(a:0)) {}
      MockDriver2.session(@driver_config.merge(a:1)) {}

      expect(MockDriver::DriverConnectionPool.length).to eq(2)
      expect(MockDriver::DriverConnectionPool['MockDriver2'].length).to eq(3)
      expect(MockDriver::DriverConnectionPool['MockDriver2'][0].length).to  eq(2)
      expect(MockDriver::DriverConnectionPool['MockDriver2'][0].has_key? :config).to  be_true
      expect(MockDriver::DriverConnectionPool['MockDriver2'][0].has_key? :pool).to    be_true
    end

  end
end