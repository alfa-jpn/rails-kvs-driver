require 'rails_kvs_driver/sorted_set'
module RailsKvsDriver
  module DefinedBaseMethod
    # initialize driver.
    # @param kvs_instance  [Object] instance of key-value store.
    # @param driver_config [Hash]   driver config.
    def initialize(kvs_instance, driver_config)
      @kvs_instance  = kvs_instance
      @driver_config = driver_config
    end

    # return initialized SortedSet class.
    #
    def sorted_sets
      RailsKvsDriver::SortedSet.new(self)
    end

    # execute the block of code for each key having string, and value.
    # @param &block   [{|key, value| }] each the block of code for each key having string, and value.
    def each
      keys.each {|key| yield key, self[key] }
    end

    # get length of keys.
    def length
      keys.length
    end

  end
end