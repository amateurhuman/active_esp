module ActiveESP
  module Providers
    module Interface
      # Subscription methods

      def find_subscriber(params); end
      def subscribe(subscriber, list = nil); end
      def unsubscribe(subscriber, list = nil); end
      def subscribed?(subscriber, list = nil); end

      # List methods
      
      def lists; end
    end
  end
end
