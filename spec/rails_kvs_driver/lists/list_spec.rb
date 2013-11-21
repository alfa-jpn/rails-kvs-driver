require 'rspec'
require 'spec_helper'

describe RailsKvsDriver::Lists::List do

  before(:each) do
    @driver = MockDriver.new(nil,nil)
    @driver.stub({
        count_list_value:        100,
        delete:                  true,
        delete_list_value:       true,
        delete_list_value_at:    true,
        get_list_keys:           [:a,:b,:c],
        get_list_value:          'Nyarukosan',
        get_list_values:         [:Nyarukosan],
        push_list_first:         5,
        push_list_last:          5,
        pop_list_first:          'Nyarukosan',
        pop_list_last:           'Nyarukosan',
        set_list_value:          ''
    })
  end

  it 'call []' do
    expect((@driver.lists[:key][:list_key]).instance_of?(String)).to be_true
  end

  it 'call []=' do
    expect(@driver.lists[:key][:list_key] = 'hogehoge').to eq('hogehoge')
  end

  it 'call delete' do
    expect(@driver.lists[:key].delete(:a)).to be_true
  end

  it 'call delete_at' do
    expect(@driver.lists[:key].delete(1)).to be_true
  end

  it 'call each' do
    count = 0
    expect{
      @driver.lists[:key].each do |key|
        count += 1
      end
    }.to change{count}.by(100)
  end

  it 'call length' do
    expect(@driver.lists[:key].length).to eq(100)
  end

  it 'call size' do
    expect(@driver.lists[:key].size).to eq(100)
  end

end