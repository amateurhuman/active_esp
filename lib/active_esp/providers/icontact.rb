module ActiveESP
  module Providers
    # This is the implementation for version 2.0 of iContact's API.
    #
    # == Example Usage
    #   ActiveESP.configure do |c|
    #    c.provider :icontact
    #    c.credentials :app_id => '1234567890',
    #                  :username => 'testuser',
    #                  :password => 'password',
    #                  :api_version => '2.0'
    #  end
    #  
    #  list = ActiveESP::List.new(:id => 123)
    #  subscriber = ActiveESP::Subscriber.new(
    #    :email => 'user@example.com',
    #    :name => 'Brian Morton'
    #  )
    #  
    #  ActiveESP.provider.subscribe(subscriber, list)
    #
    class IContact < Base
      include HTTParty
      format :plain
      self.endpoint = 'https://app.icontact.com/icp'

      # Returns or sets the application ID provided by iContact
      #
      # @see https://app.icontact.com/icp/core/registerapp/
      # @return [String]
      attr_accessor :app_id

      # Returns or sets the username of the account associated with
      # the application ID.
      #
      # @see https://app.icontact.com/icp/core/registerapp/
      # @see http://developer.icontact.com/documentation/authenticate-requests/
      # @return [String]
      attr_accessor :username

      # Returns or sets the password of the username or application ID
      # provided.
      #
      # @see https://app.icontact.com/icp/core/registerapp/
      # @see http://developer.icontact.com/documentation/authenticate-requests/
      # @return [String]
      attr_accessor :password

      # The version of the iContact API that is being accessed.
      # 
      # Currently only version 2.0 is supported.  This is for backporting
      # functionality for 1.0 or supporting future versions of the API.
      #
      # @see http://developer.icontact.com/documentation/authenticate-requests/
      # @return [String]
      attr_accessor :api_version

      # Interface implementation

      # Find a contact stored in the iContact account.
      #
      # @see ActiveESP::Providers::Interface#find_subscriber
      def find_subscriber(params)
        response = call(:get, "/a/#{account_id}/c/#{client_folder_id}/contacts", params)
        return [] unless response['contacts']

        response['contacts'].map do |contact|
          contact_as_subscriber(contact)
        end
      end

      # Create a contact and optionally subscribe them to a provided list.
      #
      # Note: On iContact, a user cannot be subscribed to a list that they have
      # previously unsubscribed from.
      #
      # @see ActiveESP::Providers::Interface#subscribe
      def subscribe(subscriber, list = nil)
        response = call(:post, "/a/#{account_id}/c/#{client_folder_id}/contacts", [{:email => subscriber.email, :firstName => subscriber.first_name, :lastName => subscriber.last_name}])
        subscriber.id = response['contacts'].first['contactId']
        if list
          list_response = call(:post, "/a/#{account_id}/c/#{client_folder_id}/subscriptions", [{:listId => list.id, :contactId => subscriber.id, :status => 'normal' }])
          raise ActiveESP::Providers::CouldNotSubscribeToListException, list_response['warnings'] if list_response['warnings']
        end
        subscriber
      end

      # Unsubscribe a subscriber from the provided list.
      #
      # @see ActiveESP::Providers::Interface#unsubscribe
      def unsubscribe(subscriber, list)
        response = call(:post, "/a/#{account_id}/c/#{client_folder_id}/subscriptions/#{list.id}_#{subscriber.id}", :status => 'unsubscribed')

        raise ActiveESP::Providers::CouldNotUnsubscribeFromListException, response['warnings'] if response['warnings']
        raise ActiveESP::Providers::CouldNotUnsubscribeFromListException, response['errors'] if response['errors']
      end

      # Retrieve an array of lists
      #
      # @see ActiveESP::Providers::Interface#lists
      def lists
        call(:get, "/a/#{account_id}/c/#{client_folder_id}/lists")
      end

      # Getting iContact-specific account information

      # Retrieves the iContact account information attached to the credentials
      # provided.
      #
      # @see http://developer.icontact.com/documentation/request-your-accountid-and-clientfolderid/
      # @return [Array] An array with hashes of the associated account information
      def account
        call(:get, '/a')
      end

      # Retrieves the iContact client folders for the account.
      #
      # @see http://developer.icontact.com/documentation/request-your-accountid-and-clientfolderid/
      # @return [Array] An array with hashes of the client folders
      def client_folders
        call(:get, "/a/#{account_id}/c")
      end

      # Retrieving account information necessary for API calls

      # Retrieves the account ID associated with the credentials in cases where it
      # is not provided with the credentials.
      #
      # Note: You should *always* specify the account ID manually by setting
      # account_id so that an additional API request doesn't need to be made
      # to retrieve it.
      #
      # @see http://developer.icontact.com/documentation/request-your-accountid-and-clientfolderid/
      # @return [Array] An array with hashes of the client folders
      def account_id
        @account_id ||= account['accounts'].first['accountId']
      end
      attr_writer :account_id

      # Retrieves the client folder ID of the first folder returned.
      #
      # This ID is required to make API calls.  It is recommended that it is
      # set with the credentials, but if it is not, an attempt will be made
      # to determine it via an API call.
      #
      # Note: You should *always* specify the folder ID manually by setting
      # client_folder_id so that an additional API request doesn't need to be
      # made to retrieve it.
      #
      # @see http://developer.icontact.com/documentation/request-your-accountid-and-clientfolderid/
      # @return [Array] An array with hashes of the client folders
      def client_folder_id
        @client_folder_id ||= client_folders['clientfolders'].first['clientFolderId']
      end
      attr_writer :client_folder_id

      # Representing iContact models as ActiveESP models

      # Returns a new ActiveESP::Subscriber object from a contact hash returned from
      # an iContact response.
      #
      # @param [Hash] contact A single contact from an iContact response
      # @return [Subscriber] Returns a new Subscriber object
      def contact_as_subscriber(contact)
        Subscriber.new(
          :first_name => contact['firstName'],
          :last_name => contact['lastName'],
          :email => contact['email'],
          :id => contact['contactId']
        )
      end

    private
      def call(method, resource, params = {})
        self.class.base_uri self.endpoint
        body = params.to_json
        response = self.class.send(method, resource, :headers => headers, :body => body)

        JSON.parse(response.body)
      end

      def headers
        { 'Accept' => 'application/json',
          'Content-Type' => 'application/json',
          'API-Version' => api_version,
          'API-AppId' => app_id,
          'API-Username' => username,
          'API-Password' => password }
      end
    end
  end
end