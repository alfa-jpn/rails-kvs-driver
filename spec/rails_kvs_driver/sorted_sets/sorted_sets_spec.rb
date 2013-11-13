require 'rspec'
require 'spec_helper'

describe RailsKvsDriver::SortedSets::SortedSets do

  before(:each) do
    @driver = MockDriver.new(nil,nil)
    @driver.stub({
        add_sorted_set:          nil,
        count_sorted_set_member: 100,
        delete:                  true,
        get_sorted_set:          [[:a,:b],[:c,:d]],
        get_sorted_set_keys:     [:a,:b,:c],
        get_sorted_set_score:    100,
        increment_sorted_set:    10,
        remove_sorted_set:       true
    })
  end

  it 'call []' do
    sorted_set = [['member', 1],['member', 2]]
    expect(@driver.sorted_sets[:key] = sorted_set).to eq(sorted_set)
  end

  it 'call []=' do
    expect((@driver.sorted_sets[:key]).instance_of?(RailsKvsDriver::SortedSets::SortedSet)).to be_true
  end

  it 'call delete' do
    expect(@driver.sorted_sets.delete(:a)).to be_true
  end

  it 'call each' do
    count = 0
    expect{
      @driver.sorted_sets.each do |key|
        count += 1
      end
    }.to change{count}.by(3)
  end

  it 'call has_key?' do
    expect(@driver.sorted_sets.has_key?(:a)).to be_true
  end

  it 'call keys' do
    expect(@driver.sorted_sets.keys.length).to eq(3)
  end

  it 'call length' do
    expect(@driver.sorted_sets.length).to eq(3)
  end

end