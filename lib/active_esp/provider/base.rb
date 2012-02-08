module ActiveESP
  # A +Provider+ in ActiveESP is an individual ESP class that implements the required
  # methods to conform to a +Provider+ protocol.
  #
  # To make things work smoothly, the framework expects a +Provider+ to extend from
  # +ActiveESP::Provider::Base+. This allows common functionality to be shared
  # amongst the providers as well as exceptions to be raised when the provider
  # doesn't implement a required method.
  #
  module Provider
    class Base
      # Returns or sets the API key
      #
      # @return [String]
      attr_accessor :api_key

      # Sets the endpoint base URL without a trailing slash
      #
      # @return [String]
      attr_writer :endpoint
      cattr_accessor :endpoint

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

      def endpoint
        if defined?(@endpoint)
          @endpoint
        elsif superclass != Object && superclass.endpoint
          superclass.endpoint
        else
          @endpoint ||= ''
        end
      end

      def subscribe(subscriber, list = nil)
        raise MethodNotImplementedException
      end
    end

    class MethodNotImplementedException < Exception; end
  end
end