module ActiveESP
  module Provider
    module Interface
      def subscribe(subscriber, list = nil); end;
      def unsubscribe(subscriber, list = nil); end;
    end
  end
end
