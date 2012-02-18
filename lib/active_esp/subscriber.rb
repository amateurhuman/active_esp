module ActiveESP
  # A +Subscriber+ object represents an email address stored within a service provider's
  # system.
  #
  # At the very least, an email address is required to have a valid subscriber.  If a name
  # is also necessary, a +requires_name+ flag can be set on the class to indicate to the
  # validator that it needs to check for a name as well.
  #
  # Email address are validated against the spec set forth in RFC822:
  # http://www.w3.org/Protocols/rfc822/#z8
  #
  # == Example Usage
  #   subscriber = ActiveESP::Subscriber.new(
  #     :first_name => 'Billie Joe',
  #     :last_name  => 'Armstong',
  #     :email      => 'billie.joe@example.com'
  #   )
  #
  #   subscriber.name   # => 'Billie Joe Armstrong'
  #   subscriber.valid? # => true
  #
  class Subscriber
    include RFC822

    # Forces a first and last name to be present for the object to be valid.
    # If true, the name is required.  The default value is false.
    #
    # @return [Boolean]
    cattr_accessor :requires_name
    self.requires_name = false

    # Returns or sets the subscriber's ID as determined by the provider
    #
    # @return [String]
    attr_accessor :id

    # Returns or sets the subscriber's email address
    #
    # @return [String]
    attr_accessor :email

    # Returns or sets the subscriber's first name
    #
    # @return [String]
    attr_accessor :first_name

    # Returns or sets the subscriber's last name
    #
    # @return [String]
    attr_accessor :last_name

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

    # Returns the full name of the subscriber.
    #
    # @return [String] the full name of the subscriber
    def name
      [@first_name, @last_name].compact.join(' ')
    end

    # Assigns first and last names based on specifiying a full name string
    #
    # @param [String] full_name The subscriber's full name to be split programatically
    def name=(full_name)
      names = full_name.split
      self.last_name  = names.pop
      self.first_name = names.join(" ")
    end

    # Returns whether either the +first_name+ or the +last_name+ attributes has been set.
    def name?
      first_name? || last_name?
    end

    # Returns whether the +first_name+ attribute has been set.
    def first_name?
      @first_name.present?
    end

    # Returns whether the +last_name+ attribute has been set.
    def last_name?
      @last_name.present?
    end

    def valid?
      valid_email? && valid_name?
    end

    def valid_email?
      @email =~ EmailAddress
    end

    def valid_name?
      return false if self.class.requires_name && !name?
      return true
    end

    # Accessing commonly used API calls

    def create!
      raise ActiveESP::ProviderNotConfiguredException unless ActiveESP.provider
      raise ActiveESP::SubscriberInvalid
      ActiveESP.provider.create_subscriber(self)
    end

    # Add the subscriber to the provider and optionally subscribe them to the
    # given list.
    #
    # @see ActiveESP::Providers::Interface#subscribe
    def subscribe!(list = nil)
      raise ActiveESP::ProviderNotConfiguredException unless ActiveESP.provider
      ActiveESP.provider.subscribe_to_list(self, list)
    end

    # Remove the subscriber from the given list.
    #
    # @see ActiveESP::Providers::Interface#unsubscribe
    def unsubscribe!(list)
      raise ActiveESP::ProviderNotConfiguredException unless ActiveESP.provider
      ActiveESP.provider.unsubscribe(self, list)
    end

    class << self
      def find(params)
        raise ActiveESP::ProviderNotConfiguredException unless ActiveESP.provider
        ActiveESP.provider.find_subscriber(params)
      end
    end
  end
end
