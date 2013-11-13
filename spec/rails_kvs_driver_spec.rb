require 'rspec'
require 'spec_helper'

describe RailsKvsDriver::Base do
  it 'raise NoMethodError when does not override connect' do
    expect(RailsKvsDriver::Base.public_class_method('connect')).to be_true
    expect{RailsKvsDriver::Base.connect('dummy')}.to raise_error(NoMethodError)
  end

  it 'raise NoMethodError when does not override get' do
    expect(MockDriver.method_defined?('get')).to be_true
    expect{MockDriver.new(nil,nil).get(nil)}.to raise_error(NoMethodError)
  end

  it 'raise NoMethodError when does not override set' do
    expect(MockDriver.method_defined?('set')).to be_true
    expect{MockDriver.new(nil,nil).set(nil,nil)}.to raise_error(NoMethodError)
  end

  it 'raise NoMethodError when does not override keys' do
    expect(MockDriver.method_defined?(:keys)).to be_true
    expect{MockDriver.new(nil,nil).keys}.to raise_error(NoMethodError)
  end

  it 'raise NoMethodError when does not override delete' do
    expect(MockDriver.method_defined?(:delete)).to be_true
    expect{MockDriver.new(nil,nil).delete(nil)}.to raise_error(NoMethodError)
  end

  it 'raise NoMethodError when does not override delete_all' do
    expect(MockDriver.method_defined?(:delete_all)).to be_true
    expect{MockDriver.new(nil,nil).delete_all}.to raise_error(NoMethodError)
  end

  it 'raise NoMethodError when does not override add_sorted_set' do
    expect(MockDriver.method_defined?(:add_sorted_set)).to be_true
    expect{MockDriver.new(nil,nil).add_sorted_set(nil,nil,nil)}.to raise_error(NoMethodError)
  end

  it 'raise NoMethodError when does not override get_sorted_set' do
    expect(MockDriver.method_defined?(:get_sorted_set)).to be_true
    expect{MockDriver.new(nil,nil).get_sorted_set(nil)}.to raise_error(NoMethodError)
  end

  it 'raise NoMethodError when does not override get_sorted_set_keys' do
    expect(MockDriver.method_defined?(:get_sorted_set_keys)).to be_true
    expect{MockDriver.new(nil,nil).get_sorted_set_keys}.to raise_error(NoMethodError)
  end

  it 'raise NoMethodError when does not override count_sorted_set_member' do
    expect(MockDriver.method_defined?(:count_sorted_set_member)).to be_true
    expect{MockDriver.new(nil,nil).count_sorted_set_member(nil)}.to raise_error(NoMethodError)
  end

  it 'raise NoMethodError when does not override get_sorted_set_score' do
    expect(MockDriver.method_defined?(:get_sorted_set_score)).to be_true
    expect{MockDriver.new(nil,nil).get_sorted_set_score(nil,nil)}.to raise_error(NoMethodError)
  end

  it 'raise NoMethodError when does not override increment_sorted_set' do
    expect(MockDriver.method_defined?(:increment_sorted_set)).to be_true
    expect{MockDriver.new(nil,nil).increment_sorted_set(nil,nil,nil)}.to raise_error(NoMethodError)
  end

  it 'raise NoMethodError when does not override remove_sorted_set' do
    expect(MockDriver.method_defined?(:remove_sorted_set)).to be_true
    expect{MockDriver.new(nil,nil).remove_sorted_set(nil,nil)}.to raise_error(NoMethodError)
  end
end