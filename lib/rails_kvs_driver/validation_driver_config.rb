module RailsKvsDriver
  module ValidationDriverConfig
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

      driver_config[:config_key] = :none  unless driver_config.has_key? :config_key

      return driver_config
    end

    # raise argument error.
    #
    # @param key [String] not exists key.
    def raise_argument_error!(key)
      raise ArgumentError, "driver_config does not include #{key}"
    end
  end
end