require 'rails_kvs_driver/sorted_sets/sorted_set'
require 'rails_kvs_driver/common_methods/keys'

module RailsKvsDriver
  module SortedSets
    class SortedSets
      include RailsKvsDriver::CommonMethods::Keys

      attr_accessor :driver_instance

      # initialize sorted_sets
      #
      # @param driver_instance [RailsKvsDriver::Base]
      def initialize(driver_instance)
        @driver_instance = driver_instance
      end

      # get sorted_set.
      #
      # @param key    [String] sorted_set key.
      # @return [SortedSet] sorted_set of key.
      def [](key)
        SortedSet.new(@driver_instance, key)
      end

      # add new sorted_set.
      # if key exists, delete old sorted_set.
      #
      # @param key [String] sorted_set key.
      # @param member_sets [Array<Array<member,score>>] array of array of member<String> and score<Float>.
      # @return [Array<Array<member,score>>] meber_sets
      def []=(key, member_sets)
        delete(key) if has_key?(key)
        sorted_set = self[key]
        member_sets.each {|member_set| sorted_set[member_set[0]] = member_set[1]}
      end

      # delete sorted_set.
      #
      # @param key [String] key of sorted_set.
      def delete(key)
        @driver_instance.delete(key)
      end

      # get all keys from kvs.
      #
      # @return [Array<String>] array of key names.
      def keys
        @driver_instance.get_sorted_set_keys
      end

    end
  end
end
