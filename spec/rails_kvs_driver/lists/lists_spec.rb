require 'rspec'
require 'spec_helper'

describe RailsKvsDriver::Lists::Lists do

  before(:each) do
    @driver = MockDriver.new(nil,nil)
    @driver.stub({
        count_list_value:        100,
        delete:                  true,
        delete_list_value:       true,
        delete_list_value_at:    true,
        get_list_keys:           [:a,:b,:c],
        get_list_value:          'Nyarukosan',
        push_list_first:         5,
        push_list_last:          5,
        pop_list_first:          'Nyarukosan',
        pop_list_last:           'Nyarukosan',
        set_list_value:          ''
    })
  end

  it 'call methods of Enumerable' do
    expect(@driver.lists.count).to eq(3)
  end

  it 'call []' do
    expect((@driver.lists[:key]).instance_of?(RailsKvsDriver::Lists::List)).to be_true
  end

  it 'call []=' do
    sorted_set = [:a,:b,:c]
    expect(@driver.lists[:key] = sorted_set).to eq(sorted_set)
  end

  it 'call delete' do
    expect(@driver.lists.delete(:a)).to be_true
  end

  it 'call each' do
    count = 0
    expect{
      @driver.lists.each do |key|
        count += 1
      end
    }.to change{count}.by(3)
  end

  it 'call has_key?' do
    expect(@driver.lists.has_key?(:a)).to be_true
  end

  it 'call keys' do
    expect(@driver.lists.keys.length).to eq(3)
  end

  it 'call length' do
    expect(@driver.lists.length).to eq(3)
  end

  it 'call size' do
    expect(@driver.lists.size).to eq(3)
  end

end