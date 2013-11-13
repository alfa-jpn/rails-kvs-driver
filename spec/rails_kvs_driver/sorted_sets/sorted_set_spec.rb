require 'rspec'
require 'spec_helper'

describe RailsKvsDriver::SortedSets::SortedSet do

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
    expect(@driver.sorted_sets[:key][:member] = 1).to eq(1)
  end

  it 'call []=' do
    expect(@driver.sorted_sets[:key][:member]).to eq(100)
  end

  it 'call length' do
    expect(@driver.sorted_sets[:key].length).to eq(100)
  end

  it 'call each' do
    count = 0
    expect{
      @driver.sorted_sets[:key].each(false, 10) do |member, score, position|
        expect(position).to eq(count)
        count += 1
      end
    }.to change{count}.by(100)
  end

  it 'call has_member?' do
    expect(@driver.sorted_sets[:key].has_member?(:a)).to be_true
  end

  it 'call increment' do
    expect( @driver.sorted_sets[:key].increment(:b, 1) ).to eq(10)
  end

  it 'call length' do
    expect(@driver.sorted_sets[:key].length).to eq(100)
  end

  it 'call members' do
    expect(@driver.sorted_sets[:key].members.length).to eq(100)
  end

  it 'call remove' do
    expect(@driver.sorted_sets[:key].remove(:b)).to be_true
  end
end