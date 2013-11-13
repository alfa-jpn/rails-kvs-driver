require 'rails_kvs_driver/sorted_sets/sorted_sets'

module RailsKvsDriver
  module DefinedBaseMethod
    # initialize driver.
    # @param kvs_instance  [Object] instance of key-value store.
    # @param driver_config [Hash]   driver config.
    def initialize(kvs_instance, driver_config)
      @kvs_instance  = kvs_instance
      @driver_config = driver_config
    end

    # get string value from kvs.
    # @param key [String] key.
    # @return [String] value. when doesn't exist, nil
    # @abstract get value from kvs. when doesn't exist, nil
    def [](key)
      get(key)
    end

    # set string value to kvs.
    # @param key    [String] key.
    # @param value  [String] value.
    # @return [Boolean] result
    # @abstract set value to kvs.
    def []=(key, value)
      set(key, value)
    end

    # return initialized SortedSet class.
    #
    # @return [RailsKvsDriver::SortedSets] SortedSet
    def sorted_sets
      SortedSets::SortedSets.new(self)
    end

    # execute the block of code for each key having string, and value.
    # @param &block   [{|key, value| }] each the block of code for each key having string, and value.
    def each
      keys.each {|key| yield key, self[key] }
    end

    # check key in redis.
    #
    # @param key [String] key name
    # @return [Boolean] result
    def has_key?(key)
      !(self[key].nil?)
    end

    # get length of keys.
    #
    # @return [Integer]length of keys.
    def length
      keys.length
    end

  end
end
