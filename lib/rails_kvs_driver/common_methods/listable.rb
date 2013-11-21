module RailsKvsDriver
  module CommonMethods
    # common functions for keys.
    module Listable
      # execute the block of code for each sorted_set.
      #
      # @param &block   [{|key, value| }] each the block of code for each key having string, and value.
      def each
        keys.each {|key| yield key, self[key] }
      end

      # kvs check empty.
      #
      # @return [Boolean] result.
      def empty?
        (length<1)
      end

      # check key in sorted set.
      #
      # @param key [String] key name.
      # @return [Boolean] result.
      def has_key?(key)
        keys.include?(key)
      end

      # get length of sorted_set.
      #
      # @return [Integer] length of keys.
      def length
        keys.length
      end

      alias size length
    end
  end
end