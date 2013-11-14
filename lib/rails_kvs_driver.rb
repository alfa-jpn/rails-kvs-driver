require 'rails_kvs_driver/version'
require 'rails_kvs_driver/session'
require 'rails_kvs_driver/defined_base_method'

module RailsKvsDriver
  # This abstract class wrap accessing to Key-Value Store.
  # @abstract
  class Base
    extend RailsKvsDriver::Session
    include RailsKvsDriver::DefinedBaseMethod

    # @attr @kvs_instance [Object] instance of KVS.
    attr_accessor :kvs_instance

    # @attr @driver_config [Hash] config of driver.
    #  {
    #     :host           => 'localhost', # host of KVS.
    #     :port           => 6379,        # port of KVS.
    #     :namespace      => 'Example',   # namespace of avoid a conflict with key
    #     :timeout_sec    => 5,           # timeout seconds.
    #     :pool_size      => 5,           # connection pool size.
    #     :config_key     => :none,       # this key is option.(defaults=:none)
    #                                     #  when set this key.
    #                                     #  will refer to a connection-pool based on config_key,
    #                                     #  even if driver setting is the same without this key.
    #   }
    attr_accessor :driver_config

    # connect with driver config.
    # @param driver_config [Hash]   driver config.
    # @return [Object] instance of key-value store.
    # @abstract connect with driver config. and return instance of kvs.
    def self.connect(driver_config)
      raise NoMethodError
    end

    # get string value from kvs.
    # @param key [String] key.
    # @return [String] value. when doesn't exist, nil
    # @abstract get value from kvs. when doesn't exist, nil
    def get(key)
      raise NoMethodError
    end

    # set string value to kvs.
    # @param key    [String] key.
    # @param value  [String] value.
    # @return [Boolean] result
    # @abstract set value to kvs.
    def set(key, value)
      raise NoMethodError
    end

    # get all keys from kvs.
    # @return [Array<String>] array of key names.
    # @abstract get all keys from kvs.(only having string value)
    def keys
      raise NoMethodError
    end

    # delete key from kvs.
    # @return [Boolean] result.
    # @abstract delete key from kvs.
    def delete(key)
      raise NoMethodError
    end

    # delete all keys from kvs.
    # @return [Boolean] result.
    # @abstract delete all keys from kvs.
    def delete_all
      raise NoMethodError
    end



    #--------------------
    # list (same as list of redis. refer to redis.)
    #--------------------

    # count value of the list.
    # when the key doesn't exist, return 0.
    #
    # @param key [String] key of the list.
    # @return [Integer] number.
    # @abstract count value of the list.
    def count_list_value(key)
      raise NoMethodError
    end

    # delete value from list.
    #
    # @param key    [String] key of the list.
    # @param value  [String] delete value.
    # @abstract delete value from list.
    def delete_list_value(key, value)
      raise NoMethodError
    end

    # delete at index from list.
    #
    # @param key    [String] key of the list.
    # @param index  [Integer] index of the list.
    # @abstract delete at index from list.
    def delete_list_value_at(key, index)
      raise NoMethodError
    end

    # get all keys of existed list.
    #
    # @return [Array<String>] keys.
    # @abstract get all keys of existed list.
    def get_list_keys
      raise NoMethodError
    end

    # get value from index of the list.
    # when the key doesn't exist, return nil.
    #
    # @param key    [String] key of the list.
    # @param index  [Integer] index of the list.
    # @return [String] value.
    # @abstract get value from index of the list.
    def get_list_value(key, index)
      raise NoMethodError
    end

    # get values from index of the list.
    # @example get_list_value(:key) => get all.
    # @example get_list_value(:key, 5, 10) => 5~10 return total 6 values.
    #
    # @param key    [String]  key of the list.
    # @param start  [Integer] start index of the list.
    # @param stop   [Integer] end index of the list.
    # @return [Array<String>] value.
    # @abstract get values from index of the list.
    def get_list_values(key, start=0, stop=-1)
      raise NoMethodError
    end

    # push value to first of the list.
    # when the key doesn't exist, it's made newly list.
    #
    # @param key    [String] key of list.
    # @param value  [String] push value.
    # @return [Integer] length of list after push.
    # @abstract push value to first of the list.
    def push_list_first(key, value)
      raise NoMethodError
    end

    # push value to last of the list.
    # when the key doesn't exist, it's made newly list.
    #
    # @param key    [String] key of list.
    # @param value  [String] push value.
    # @return [Integer] length of list after push.
    # @abstract push value to last of the list.
    def push_list_last(key, value)
      raise NoMethodError
    end

    # pop value from first of the list.
    # when the key doesn't exist or is empty. return nil.
    #
    # @param key [String] key of the list.
    # @return [String] value of the key.
    # @abstract pop value from first of the list.
    def pop_list_first(key)
      raise NoMethodError
    end

    # pop value from first of the list.
    # when the key doesn't exist or is empty. return nil.
    #
    # @param key [String] key of the list.
    # @return [String] value of the key.
    # @abstract pop value from last of the list.
    def pop_list_last(key)
      raise NoMethodError
    end

    # set value to index of the list.
    #
    # @param key    [String] key of the list.
    # @param index  [Integer] index of the list.
    # @param value  [String] set value.
    # @abstract set value to index of the list.
    def set_list_value(key, index, value)
      raise NoMethodError
    end



    #--------------------
    # sorted set (same as sorted set of redis. refer to redis.)
    #--------------------

    # add sorted set to kvs.
    # when the key doesn't exist, it's made newly.
    # @note same as sorted set of redis. refer to redis.
    #
    # @param key    [String]  key of sorted set.
    # @param member [String]  member of sorted set.
    # @param score  [Float]   score of sorted set.
    # @return [Boolean] result.
    # @abstract add sorted set to kvs.
    def add_sorted_set(key, member, score)
      raise NoMethodError
    end

    # count members of sorted set
    # @note same as sorted set of redis. refer to redis.
    #
    # @param key [String]  key of sorted set.
    # @return [Integer] members num. when doesn't exist key, return nil
    # @abstract count members of sorted set. when doesn't exist key, return nil
    def count_sorted_set_member(key)
      raise NoMethodError
    end

    # get array of sorted set.
    # @note same as sorted set of redis. refer to redis.
    #
    # @param key      [String]  key of sorted set.
    # @param start    [Integer] start index
    # @param stop     [Integer] stop index
    # @param reverse  [Boolean] order by desc.
    # @return [Array<String, Float>>] array of the member and score. when doesn't exist, nil.
    # @abstract get array of sorted set. when doesn't exist, nil.
    def get_sorted_set(key, start=0, stop=-1, reverse=false)
      raise NoMethodError
    end

    # get all sorted_set keys.
    # @return [Array<String>] array of key names. when doesn't exist keys, return Array of length 0.
    # @abstract get all keys from kvs.(only having sorted_set), when doesn't exist keys, return Array of length 0.
    def get_sorted_set_keys
      raise NoMethodError
    end

    # get the score of member.
    # @note same as sorted set of redis. refer to redis.
    #
    # @param key    [String]  key of sorted set.
    # @param member [String]  member of sorted set.
    # @return [Float] score of member. when doesn't exist key or member, nil.
    # @abstract get the score of member. when doesn't exist key or member, nil.
    def get_sorted_set_score(key, member)
      raise NoMethodError
    end

    # increment score of member from sorted set.
    # @note same as sorted set of redis. refer to redis.
    #
    # @param key    [String]  key of sorted set.
    # @param member [String]  member of sorted set.
    # @param score  [Float]   increment score.
    # @return [Float] value after increment. when doesn't exist key or member, create.
    # @abstract increment score of member from sorted set. when doesn't exist key or member, create.
    def increment_sorted_set(key, member, score)
      raise NoMethodError
    end

    # remove sorted set from kvs.
    # This function doesn't delete a key.
    # @note same as sorted set of redis. refer to redis.
    #
    # @param key    [String]  key of sorted set.
    # @param member [String]  member of sorted set.
    # @return [Boolean] result. when doesn't exist key or member, false.
    # @abstract remove sorted set from kvs. when doesn't exist key or member, do nothing.
    def remove_sorted_set(key, member)
      raise NoMethodError
    end

  end
end
