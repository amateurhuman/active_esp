module ActiveESP
  module Providers
    class MailChimp < Base
      include HTTParty
      format :plain

      def endpoint
        "https://#{dc_from_api_key}api.mailchimp.com/1.3"
      end

      def subscribe(subscriber, list)
        call(:list_subscribe, { :id => list.id, :email_address => subscriber.email, :merge_vars => { :FNAME => subscriber.first_name, :LNAME => subscriber.last_name }})
      end

      def lists
        call(:lists)
      end

    private
      # This implementation mostly comes from the MailChimp gibbon gem
      # available at: https://github.com/amro/gibbon
      def call(method, params = {})
        api_url = endpoint + '/?method=' + method.to_s.camelize(:lower)
        params = api_params(params)
        response = self.class.post(api_url, :body => CGI::escape(params.to_json), :timeout => 30)

        # Some calls (e.g. listSubscribe) return json fragments
        # (e.g. true) so wrap in an array prior to parsing
        response = JSON.parse('['+response.body+']').first

        if @throws_exceptions && response.is_a?(Hash) && response["error"]
          raise "Error from MailChimp API: #{response["error"]} (code #{response["code"]})"
        end

        response
      end

      def api_params(additional_params = {})
        { :apikey => api_key }.merge(additional_params)
      end

      def dc_from_api_key
        (!@api_key.present? || @api_key !~ /-/) ? '' : "#{@api_key.split("-").last}."
      end
    end
  end
end