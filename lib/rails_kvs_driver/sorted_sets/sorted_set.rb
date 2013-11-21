module RailsKvsDriver
  module SortedSets
    class SortedSet
      include Enumerable

      attr_accessor :driver_instance
      attr_accessor :key

      # initialize sorted_set
      #
      # @param driver_instance  [RailsKvsDriver::Base] instance of driver.
      # @param key              [String] key of sorted_set.
      def initialize(driver_instance, key)
        @driver_instance = driver_instance
        @key = key
      end

      # get score of member.
      # when the key or member doesn't exist, return 0.
      #
      # @param member [String] member of sorted_set.
      # @return [Integer] score.
      def [](member)
        @driver_instance.get_sorted_set_score(@key, member)
      end

      # add member in sorted_set.
      # when the key doesn't exist, it's made newly.
      #
      # @param member [String]  member of sorted_set.
      # @param score  [Flaot]   default score.
      # @return [Float] score.
      def []=(member, score)
        @driver_instance.add_sorted_set(@key, member, score)
        return score
      end

      # execute the block of code for each member of sorted set.
      #
      # @param reverse  [Boolean] order by desc. (default=false(acs))
      # @param limit    [Integer] limit number to acquire at a time. (default=1000)
      # @param &block   [{|member, score, position| }] each the block of code for each member of sorted set.
      def each(reverse = false, limit = 1000)
        count    = length
        position = 0

        while position < count
          @driver_instance.get_sorted_set(@key, position, position + (limit-1), reverse).each do |data|
            yield data[0], data[1], position
            position += 1
          end
        end
      end

      # check having member.
      #
      # @return [Boolean] result
      def has_member?(member)
        members.include?(member)
      end

      # increment member's score of sorted set.
      #
      # @param member [String]  member of sorted set.
      # @param score  [Float]   increment score
      # @return [Float] score after increment.
      def increment(member, score)
        @driver_instance.increment_sorted_set(@key, member, score)
      end

      # length of sorted_set
      #
      # @return [Integer] length of sorted_set
      def length
        @driver_instance.count_sorted_set_member(@key)
      end

      # get all member.
      # @return [Array<String>] array of member.
      def members
        members = Array.new
        each{|member| members.push(member)}
        return members
      end

      # remove member of sorted_set.
      #
      # @param member [String] member of sorted_set.
      def remove(member)
        @driver_instance.remove_sorted_set(@key, member)
      end

      alias size length
    end
  end
end
