require 'rails_kvs_driver/version'
require 'connection_pool'

module RailsKvsDriver
  # This abstract class wrap accessing to Key-Value Store.
  # @abstract
  class Base

    # @attr DriverConnectionPool [Hash] This Constants pools the connecting driver.
    # {
    #   driver_class_name => [{:config => driver_config, :pool => ConnectionPool }, ....  ]
    #
    #   ...
    #
    # }
    DriverConnectionPool = Hash.new

    # @attr @kvs_instance [Object] instance of KVS.
    attr_accessor :kvs_instance

    # @attr @driver_config [Hash] config of driver.
    # {
    #   :host           => 'localhost' # host of KVS.
    #   :port           => 6379        # port of KVS.
    #   :namespace      => 'Example'   # namespace of avoid a conflict with key
    #   :timeout_sec    => 5           # timeout seconds.
    #   :pool_size      => 5           # connection pool size.
    # }
    attr_accessor :driver_config

    # initialize driver, and connect kvs.
    # @param driver_config [Hash] driver config.
    def initialize(driver_config)
      @driver_config = validate_driver_config!(driver_config)
      connect
    end

    # connect with driver config.
    # @return [Boolean] result
    def connect
      raise NoMethodError
    end

    # get value from kvs.
    # @param key [String] key.
    # @return [String] value
    # @abstract get value from kvs.
    def [](key)
      raise NoMethodError
    end

    # set value to kvs.
    # @param key    [String] key.
    # @param value  [String] value.
    # @return [Boolean] result
    # @abstract set value to kvs.
    def []=(key, value)
      raise NoMethodError
    end

    # get all keys from kvs.
    # @return [Array<String>] array of key names.
    # @abstract get all keys from kvs.
    def all_keys
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

    # remove sorted set from kvs.
    # This function doesn't delete a key.
    # @note same as sorted set of redis. refer to redis.
    #
    # @param key    [String]  key of sorted set.
    # @param member [String]  member of sorted set.
    # @return [Boolean] result.
    # @abstract remove sorted set from kvs.
    def remove_sorted_set(key, member)
      raise NoMethodError
    end

    # increment score of member from sorted set.
    # @note same as sorted set of redis. refer to redis.
    #
    # @param key    [String]  key of sorted set.
    # @param member [String]  member of sorted set.
    # @param score  [Float]   increment score.
    # @return [Float] value after increment
    # @abstract increment score of member from sorted set.
    def increment_sorted_set(key, member, score)
      raise NoMethodError
    end

    # get the score of member.
    # @note same as sorted set of redis. refer to redis.
    #
    # @param key    [String]  key of sorted set.
    # @param member [String]  member of sorted set.
    # @return [Float] score of member.
    # @abstract get the score of member.
    def sorted_set_score(key, member)
      raise NoMethodError
    end

    # get array of sorted set.
    # @note same as sorted set of redis. refer to redis.
    #
    # @param key      [String]  key of sorted set.
    # @param start    [Integer] start index
    # @param stop     [Integer] stop index
    # @param reverse  [Boolean] order by desc
    # @return [Array<String, Float>>] array of the member and score.
    # @abstract get array of sorted set.
    def sorted_set(key, start=0, stop=-1, reverse=false)
      raise NoMethodError
    end

    # count members of sorted set
    # @note same as sorted set of redis. refer to redis.
    #
    # @param key [String]  key of sorted set.
    # @return [Integer] members num
    def count_sorted_set_member(key)
      raise NoMethodError
    end


    # connect kvs and exec block.
    # This function pools the connecting driver.
    #
    # @example
    #   config = {
    #     :host           => 'localhost' # host of KVS.
    #     :port           => 6379        # port of KVS.
    #     :namespace      => 'Example'   # namespace of avoid a conflict with key
    #     :timeout_sec    => 5           # timeout seconds.
    #     :pool_size      => 5           # connection pool size.
    #   }
    #   result = Driver.session(config) do |kvs|
    #     kvs['example'] = 'abc'
    #     kvs['example']
    #   end
    #
    #   puts result  # => 'abc'
    #
    # @param driver_config [Hash] driver_config.
    # @param &block [{|driver_instance| #something... }] exec block.
    # @return [Object] status
    def self.session(driver_config, &block)
      driver_connection_pool(self, driver_config).with &block
    end


    private
    # get driver connection pool
    # if doesn't exist pool, it's made newly.
    #
    # @param driver_class   [RailsKvsDriver::Base]  driver_class
    # @param driver_config  [Hash]                  driver_config
    # @return [ConnectionPool] connection pool of driver
    def self.driver_connection_pool(driver_class, driver_config)
      pool = search_driver_connection_pool(driver_class, driver_config)
      return (pool.nil?) ? set_driver_connection_pool(driver_class, driver_config) : pool
    end

    # set driver connection pool
    #
    # @param driver_class   [RailsKvsDriver::Base]  driver_class
    # @param driver_config  [Hash]                  driver_config
    # @return [ConnectionPool] connection pool of driver
    def self.set_driver_connection_pool(driver_class, driver_config)
      conf = {
          size:     driver_config[:pool_size],
          timeout:  driver_config[:timeout_sec]
      }
      pool = ConnectionPool.new(conf) { driver_class.new(driver_config) }

      DriverConnectionPool[driver_class.name] = Array.new unless DriverConnectionPool.has_key?(driver_class.name)
      DriverConnectionPool[driver_class.name].push({config: driver_config, pool: pool})

      return pool
    end

    # search driver connection pool
    #
    # @param driver_class   [RailsKvsDriver::Base]  driver_class
    # @param driver_config  [Hash]                  driver_config
    # @return [ConnectionPool] connection pool of driver, or nil
    def self.search_driver_connection_pool(driver_class, driver_config)
      DriverConnectionPool[driver_class.name].each do |pool_set|
        if pool_set[:config] == driver_config
          return pool_set[:pool]
        end
      end if DriverConnectionPool.has_key?(driver_class.name)

      return nil
    end

    # Validate driver_config.
    # This method raise ArgumentError, if missing driver_config.
    #
    # @param driver_config [Hash] driver config.
    # @return [Hash] driver_config
    def validate_driver_config!(driver_config)
      raise_argument_error!(:host)        unless driver_config.has_key? :host
      raise_argument_error!(:port)        unless driver_config.has_key? :port
      raise_argument_error!(:namespace)   unless driver_config.has_key? :namespace
      raise_argument_error!(:timeout_sec) unless driver_config.has_key? :timeout_sec
      raise_argument_error!(:pool_size)   unless driver_config.has_key? :pool_size

      return driver_config
    end

    # raise argument error.
    #
    # @param key [String] not exists key.
    def raise_argument_error!(key)
      raise "driver_config does not include #{key}", ArgumentError
    end
  end
end
