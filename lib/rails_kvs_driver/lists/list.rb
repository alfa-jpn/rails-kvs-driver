module RailsKvsDriver
  module Lists
    class List
      attr_accessor :driver_instance
      attr_accessor :key

      # initialize list
      #
      # @param driver_instance  [RailsKvsDriver::Base] instance of driver.
      # @param key              [String] key of sorted_set.
      def initialize(driver_instance, key)
        @driver_instance = driver_instance
        @key = key
      end

      # get value of the list.
      # when the key or index doesn't exist, return nil.
      #
      # @param index [Integer] index of the list.
      # @return [String] value
      def [](index)
        @driver_instance.get_list_value(@key, index)
      end

      # set value to index of the list.
      # when the key or index doesn't exist, raise error.
      #
      # @param index [Integer] index of the list.
      # @param value [String]  value
      def []=(index, value)
        @driver_instance.set_list_value(@key, index, value)
      end

      # delete value from list.
      #
      # @param value  [String] delete value.
      def delete(value)
        @driver_instance.delete_list_value(@key, value)
      end

      # delete at index from list.
      #
      # @param index  [Integer] index of the list.
      def delete_at(index)
        @driver_instance.delete_list_value_at(@key, index)
      end

      # execute the block of code for each value of the list.
      #
      # @param limit    [Integer] limit number to acquire at a time. (default=1000)
      # @param &block   [{|index, value| }] execute the block of code for each value of the list.
      def each(limit=1000)
        count    = length
        position = 0

        while position < count
          @driver_instance.get_list_values(@key, position, position + (limit-1)).each do |value|
            yield position, value
            position += 1
          end
        end
      end

      # check if a value is included.
      #
      # @param value [String] value
      # @return [Boolean] result
      def include?(value)
        each do |index, list_value|
          return true if list_value == value
        end
        return false
      end

      # return length of the list.
      def length
        @driver_instance.count_list_value(@key)
      end

      # push value to first of the list.
      # when the key doesn't exist, it's made newly list.
      #
      # @param value [String] value.
      def push_first(value)
        @driver_instance.push_list_first(@key, value)
      end

      # push value to last of the list.
      # when the key doesn't exist, it's made newly list.
      #
      # @param value [String] value.
      def push_last(value)
        @driver_instance.push_list_last(@key, value)
      end

      # pop value from first of the list.
      # when the key doesn't exist or is empty. return nil.
      #
      # @return [String] value of the key.
      def pop_first
        @driver_instance.pop_list_first(@key)
      end

      # pop value from last of the list.
      # when the key doesn't exist or is empty. return nil.
      #
      # @return [String] value of the key.
      def pop_last
        @driver_instance.pop_list_last(@key)
      end


      alias size length
    end
  end
end