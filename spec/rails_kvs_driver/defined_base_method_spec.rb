require 'rspec'
require 'spec_helper'

describe RailsKvsDriver::DefinedBaseMethod do

  context 'call initialize' do
    it 'coping instance of driver_config' do
      expect(MockDriver.new('kvs_dummy',nil).kvs_instance).to eq('kvs_dummy')
    end

    it 'coping instance of driver_config' do
      expect(MockDriver.new(nil,@driver_config).driver_config).to eq(@driver_config)
    end
  end

  context 'call sorted_sets' do
    it 'return instance of RailsKvsDriver::SortedSet' do
      expect(MockDriver.new(nil,nil).sorted_sets.instance_of?(RailsKvsDriver::SortedSets::SortedSets)).to be_true
    end
  end

  context 'after iniaialized' do
    before(:each) do
      @instance = MockDriver.new(nil, nil)
      @instance.stub({
          :keys => [:a,:b,:c],
          :[]   => 'nyaruko'
      })
    end

    it 'call each' do
      count = 0
      expect{
        @instance.each do |key, value|
          count += 1
        end
      }.to change{count}.by(3)
    end

    it 'call has_key?' do
      expect(@instance.has_key?(:a)).to be_true
    end

    it 'call length' do
      expect(@instance.length).to eq(3)
    end
  end
end