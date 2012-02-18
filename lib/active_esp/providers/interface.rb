module ActiveESP
  module Providers
    module Interface
      # Subscription methods

      def find_subscriber(params); end
      def create_subscriber(subscriber); end
      def unsubscribe(subscriber, list = nil); end
      def subscribed?(subscriber, list = nil); end

      # List methods
      
      def lists; end
      def subscribe_to_list(subscriber, list); end
    end
  end
end
