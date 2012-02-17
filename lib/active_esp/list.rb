module ActiveESP
  class List
    # Returns or sets the list's identifier
    #
    # @return [String]
    attr_accessor :id

    # Returns or sets the list's name
    #
    # @return [String]
    attr_accessor :name

    # Initialize object with an optional attributes hash
    #
    # @param [Hash] attributes An optional hash of attributes to assign to the new instance
    def initialize(attributes = nil)
      if attributes.is_a? Hash
        attributes.each do |key, value|
          self.send(key.to_s + "=", value)
        end
      end
    end

    # Accessing commonly used API calls

    # Add the given subscriber to this list.
    #
    # @see ActiveESP::Providers::Interface#subscribe
    def subscribe!(subscriber)
      raise ActiveESP::ProviderNotConfiguredException unless ActiveESP.provider
      ActiveESP.provider.subscribe(subscriber, self)
    end

    # Remove the given subscriber from this list.
    #
    # @see ActiveESP::Providers::Interface#unsubscribe
    def unsubscribe!(subscriber)
      raise ActiveESP::ProviderNotConfiguredException unless ActiveESP.provider
      ActiveESP.provider.unsubscribe(subscriber, self)
    end
  end
end
