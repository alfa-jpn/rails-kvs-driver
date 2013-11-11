module RailsKvsDriver
  class SortedSet
    attr_accessor :driver_instance

    # initialize sorted_set
    #
    # @param driver_instance [RailsKvsDriver::Base]
    def initialize(driver_instance)
      @driver_instance = driver_instance
    end

    # get sorted_set
    # when the key doesn't exist, it's made newly.
    #
    # @param key    [String] sorted_set key.
    # @param member [String] member of sorted_set.(default=nil)
    # @return [Array<Array> or Integer] member_set[member, score]. when set member, return score of member.
    def [](key, member=nil)
      if member.nil?
        @driver_instance.get_sorted_set(key)
      else
        @driver_instance.get_sorted_set_score(key, member)
      end
    end

    # add sorted_set
    # when the key doesn't exist, it's made newly.
    #
    # @param key [String] sorted_set key
    # @param member_set [Array<member,score>] array of member<String> and score<Float>
    # @return [Array] member_set
    def []=(key, member_set)
      @driver_instance.add_sorted_set(key, member_set[0], member_set[1])
      return member_set
    end

    # delete key
    def delete(key)
      @driver_instance.delete(key)
    end

    # execute the block of code for each sorted_set.
    # @param &block   [{|key| }] each the block of code for each key of sorted set.
    def each
      keys.each {|key| yield key }
    end

    # execute the block of code for each member of sorted set.
    #
    # @param key      [String]  key of sorted set.
    # @param reverse  [Boolean] order by desc.
    # @param limit    [Integer] limit number to acquire at a time.
    # @param &block   [{|member, score, position| }] each the block of code for each member of sorted set.
    def each_member(key, reverse=false, limit=1000)
      member_count    = @driver_instance.count_sorted_set_member(key)
      member_position = 0

      while member_position < member_count
        @driver_instance.get_sorted_set(key, member_position, member_position + (limit-1), reverse).each do |data|
          yield data[0], data[1], member_position
          member_position += 1
        end
      end
    end

    # increment member's score of sorted set.
    #
    # @param key    [String]  key of sorted set.
    # @param member [String]  member of sorted set.
    # @param score  [Float]   increment score
    # @return [Float] score after increment.
    def increment(key, member, score)
      @driver_instance.increment_sorted_set(key, member, score)
    end

    # get all keys from kvs.
    # @return [Array<String>] array of key names.
    # @abstract get all keys from kvs.(only having string value)
    def keys
      @driver_instance.get_sorted_set_keys
    end

    # get length of sorted_set.
    def length
      keys.length
    end
  end
end
