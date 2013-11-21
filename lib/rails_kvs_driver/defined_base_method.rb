require 'rails_kvs_driver/lists/lists'
require 'rails_kvs_driver/sorted_sets/sorted_sets'
require 'rails_kvs_driver/common_methods/listable'

module RailsKvsDriver
  module DefinedBaseMethod
    include RailsKvsDriver::CommonMethods::Listable
    include Enumerable

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

    # return initialized SortedSets class.
    #
    # @return [RailsKvsDriver::SortedSets::SortedSets] SortedSets
    def sorted_sets
      SortedSets::SortedSets.new(self)
    end

    # return initialized lists class.
    #
    # @return [RailsKvsDriver::Lists::Lists] lists
    def lists
      Lists::Lists.new(self)
    end
  end
end
