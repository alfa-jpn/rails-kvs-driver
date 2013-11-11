require 'connection_pool'
require 'rails_kvs_driver/validation_driver_config'

module RailsKvsDriver
  # @attr DriverConnectionPool [Hash] This Constants pools the connecting driver.
  # {
  #   driver_class_name => [{:config => driver_config, :pool => ConnectionPool }, ....  ]
  #
  #   ...
  #
  # }
  KVS_CONNECTION_POOL = Hash.new


  module Session
    include RailsKvsDriver::ValidationDriverConfig

    # connect kvs and exec block.
    # This function pools the connecting driver.
    #
    # @example
    #   config = {
    #     :host           => 'localhost', # host of KVS.
    #     :port           => 6379,        # port of KVS.
    #     :namespace      => 'Example',   # namespace of avoid a conflict with key
    #     :timeout_sec    => 5,           # timeout seconds.
    #     :pool_size      => 5,           # connection pool size.
    #     :config_key     => :none        # this key is option.(defaults=:none)
    #                                     #  when set this key.
    #                                     #  will refer to a connection-pool based on config_key,
    #                                     #  even if driver setting is the same without this key.
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
    def session(driver_config, &block)
      driver_config = validate_driver_config!(driver_config)
      driver_connection_pool(self, driver_config).with do |kvs_instance|
        block.call(self.new(kvs_instance, driver_config))
      end
    end


    private
    # get driver connection pool
    # if doesn't exist pool, it's made newly.
    #
    # @param driver_class   [RailsKvsDriver::Base]  driver_class
    # @param driver_config  [Hash]                  driver_config
    # @return [ConnectionPool] connection pool of driver
    def driver_connection_pool(driver_class, driver_config)
      pool = search_driver_connection_pool(driver_class, driver_config)
      return (pool.nil?) ? set_driver_connection_pool(driver_class, driver_config) : pool
    end

    # set driver connection pool
    #
    # @param driver_class   [RailsKvsDriver::Base]  driver_class
    # @param driver_config  [Hash]                  driver_config
    # @return [ConnectionPool] connection pool of driver
    def set_driver_connection_pool(driver_class, driver_config)
      conf = {
          size:     driver_config[:pool_size],
          timeout:  driver_config[:timeout_sec]
      }
      pool = ConnectionPool.new(conf) { driver_class.connect(driver_config) }

      RailsKvsDriver::KVS_CONNECTION_POOL[driver_class.name] ||= Array.new
      RailsKvsDriver::KVS_CONNECTION_POOL[driver_class.name].push({config: driver_config, pool: pool})

      return pool
    end

    # search driver connection pool
    #
    # @param driver_class   [RailsKvsDriver::Base]  driver_class
    # @param driver_config  [Hash]                  driver_config
    # @return [ConnectionPool] connection pool of driver, or nil
    def search_driver_connection_pool(driver_class, driver_config)
      if RailsKvsDriver::KVS_CONNECTION_POOL.has_key?(driver_class.name)
        RailsKvsDriver::KVS_CONNECTION_POOL[driver_class.name].each do |pool_set|
          return pool_set[:pool] if equal_driver_config?(pool_set[:config], driver_config)
        end
      end

      return nil
    end

    # compare driver config.
    #
    # @param config1 [Hash] driver config
    # @param config2 [Hash] driver config
    def equal_driver_config?(config1, config2)
      return false unless config1[:host]        == config2[:host]
      return false unless config1[:port]        == config2[:port]
      return false unless config1[:timeout_sec] == config2[:timeout_sec]
      return false unless config1[:pool_size]   == config2[:pool_size]
      return false unless config1[:config_key]  == config2[:config_key]
      return true
    end

  end
end
