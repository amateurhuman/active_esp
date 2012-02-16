module ActiveESP
  module Configuration
    extend ActiveSupport::Concern

    module ClassMethods
      # Instantiates a shared provider singleton for access through ActiveESP.provider
      #
      # To use the configuration method, call it with a block and specify a provider and
      # any credentials that provider expects as a hash.
      #
      # == Example Usage
      #   ActiveESP.configure do |c|
      #     c.provider :mail_chimp
      #     c.credentials :api_key => '12345678901234567890-us4'
      #   end
      #
      # @param [Block] A block of method calls to set up a provider
      # @return [Provider] Returns the shared provider that was instantiated due to
      # the provided configuration
      def configure(&block)
        yield self
        reset_provider
      end

      # Returns the shared provider and optionally sets up the provider with the class
      # passed as its only argument.
      #
      # If a provider_class is provided, the method will set the class to use when
      # instantiating the shared provider.  Since provider and credentials could
      # potentially be set in any order in the configuration block, we only want
      # to try to instantiate a provider if the credentials have already been set.
      # If the credentials have not been set, a new provider will not be returned
      # until the method is called after credentials have been set.
      # 
      # == Example Usage
      #   ActiveESP.provider :mail_chimp # => nil
      #
      # If the method is called with no arguments, it will return the shared provider,
      # instantiating it if necessary.  Again, this relies on the provider class and
      # credentials being previously set.
      #
      # == Example Usage
      #   ActiveESP.provider # => #<ActiveESP::Providers::MailChimp:0x007f868b33fb30 @api_key="test">
      #
      # @param [Symbol] An optional symbol representing the provider class to use
      # @return [Provider] The shared provider object or nil if it can't be instantiated
      def provider(provider_class = nil)
        return @provider unless provider_class
        self.provider_class = provider_class

        begin
          full_provider_class_name = "ActiveESP::Providers::#{@provider_class.to_s.classify}".constantize
        rescue NameError
          raise ActiveESP::ProviderNotSupportedException.new("#{provider_class.to_s} is not a supported provider.")
        end

        @provider ||= full_provider_class_name.new(@credentials) if @credentials
      end

      # Sets the shared provider to any custom instantiated provider
      #
      # When necessary, the configuration method can be skipped and a provider can be
      # directly assigned to be the shared provider.
      #
      # == Example Usage
      #   ActiveESP.provider = ActiveESP::Providers::MailChimp.new(
      #     :api_key => '12345678901234567890-us4'
      #   )
      #
      # @param [Provider] An instance of an object in the ActiveESP::Providers namespace
      # @return [Provider] The passed provider object
      def provider=(shared_provider)
        @provider = shared_provider
      end

      # Assigns and/or returns the provider's credentials when configuring via the
      # configuration method
      #
      # This is used to help the configuration method assign credentials conveniently.
      # It works outside of the configuration block as well.
      #
      # == Example Usage
      #   ActiveESP.credentials :api_key => '12345678901234567890-us4'
      #
      # @param [Hash] provider_credentials An optional hash of values needed to
      # instantiate a provider object
      # @return [Hash] The credentials required to instantiate a provider object
      def credentials(provider_credentials = nil)
        @credentials = provider_credentials if provider_credentials
        @credentials
      end

      # Assigns the provider's credentials
      #
      # == Example Usage
      #   ActiveESP.credentials = { :api_key => '12345678901234567890-us4' }
      #
      # @param [Hash] provider_credentials A hash of values needed to instantiate a
      # provider object
      # @return [Hash] The provided credentials
      def credentials=(provider_credentials)
        @credentials = provider_credentials
      end

    private

      # Defines which provider class to use and resets the shared provider
      #
      # @return nil
      def provider_class=(klass)
        @provider_class = klass
        @provider = nil
      end

      # Clears the shared provider, reinstantiates it, and returns it
      #
      # @return [Provider] shared provider instance
      def reset_provider
        @provider = nil
        provider
      end
    end
  end
end