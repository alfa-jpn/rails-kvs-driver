require 'rails_kvs_driver/lists/list'
require 'rails_kvs_driver/common_methods/keys'

module RailsKvsDriver
  module Lists
    class Lists
      attr_accessor :driver_instance

      # initialize lists
      #
      # @param driver_instance [RailsKvsDriver::Base]
      def initialize(driver_instance)
        @driver_instance = driver_instance
      end

      # get list.
      #
      # @param key    [String] sorted_set key.
      # @return [SortedSet] sorted_set of key.
      def [](key)
        List.new(@driver_instance, key)
      end

      # add new list.
      # if key exists, delete old list.
      #
      # @param key [String] list key.
      # @param values [Array<String>] array of values.
      # @return [Array<String>] array of values.
      def []=(key, values)
        delete(key) if has_key?(key)
        list = self[key]
        values.each {|value| list.push_last(value) }
      end

      # delete list.
      #
      # @param key [String] key of list.
      def delete(key)
        @driver_instance.delete(key)
      end

      # get all list keys from kvs.
      #
      # @return [Array<String>] array of key names.
      def keys
        @driver_instance.get_list_keys
      end
    end
  end
end