require 'rspec'
require 'spec_helper'

describe RailsKvsDriver::SortedSet do

  before(:each) do
    @driver = MockDriver.new(nil,nil)
    @driver.stub({
        add_sorted_set:          nil,
        count_sorted_set_member: 100,
        delete:                  true,
        get_sorted_set:          [[:a,:b],[:c,:d]],
        get_sorted_set_keys:     [:a,:b,:c],
        get_sorted_set_score:    100,
        increment_sorted_set:    10
    })
  end

  it 'call []' do
    expect((@driver.sorted_sets['hoge'] = ['test', 1])[0]).to eq('test')
  end

  it 'call []=' do
    expect((@driver.sorted_sets['hoge'])[0][0]).to eq(:a)
    expect(@driver.sorted_sets['hoge','fuga']).to eq(100)
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

  it 'call each_member' do
    count = 0
    expect{
      @driver.sorted_sets.each_member('test',false, 10) do |member, score, position|
        expect(position).to eq(count)
        count += 1
      end
    }.to change{count}.by(100)
  end

  it 'call increment_member' do
    expect( @driver.sorted_sets.increment(:a, :b, 1) ).to eq(10)
  end

  it 'call keys' do
    expect(@driver.sorted_sets.keys.length).to eq(3)
  end

  it 'call length' do
    expect(@driver.sorted_sets.length).to eq(3)
  end
end