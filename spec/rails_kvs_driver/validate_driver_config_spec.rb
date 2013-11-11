require 'rspec'
require 'spec_helper'

describe RailsKvsDriver::ValidationDriverConfig do
  class MockValidate
    extend RailsKvsDriver::ValidationDriverConfig
  end

  context 'call validate_driver_config' do
    it 'raise ArgumentError when there is not host.' do
      @driver_config.delete(:host)
      expect{ MockValidate.validate_driver_config!(@driver_config) }.to raise_error(ArgumentError)
    end

    it 'raise ArgumentError when there is not port.' do
      @driver_config.delete(:port)
      expect{ MockValidate.validate_driver_config!(@driver_config) }.to raise_error(ArgumentError)
    end

    it 'raise ArgumentError when there is not namespace.' do
      @driver_config.delete(:namespace)
      expect{ MockValidate.validate_driver_config!(@driver_config) }.to raise_error(ArgumentError)
    end

    it 'raise ArgumentError when there is not timeout_sec.' do
      @driver_config.delete(:timeout_sec)
      expect{ MockValidate.validate_driver_config!(@driver_config) }.to raise_error(ArgumentError)
    end

    it 'raise ArgumentError when there is not pool_size.' do
      @driver_config.delete(:pool_size)
      expect{ MockValidate.validate_driver_config!(@driver_config) }.to raise_error(ArgumentError)
    end

    it 'insert default value when there is not config_key' do
      @driver_config[:config_key] = :Nyarukosan
      validated_config = MockValidate.validate_driver_config!(@driver_config)
      expect(validated_config[:config_key]).to eq(:Nyarukosan)

      @driver_config.delete(:config_key)
      validated_config = MockValidate.validate_driver_config!(@driver_config)
      expect(validated_config[:config_key]).to eq(:none)
    end
  end
end