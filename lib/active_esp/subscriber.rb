module ActiveESP
  class Subscriber
    include RFC822

    # Forces a first and last name to be present for the object to be valid.
    # If true, the name is required.  The default value is false.
    #
    # @return [Boolean]
    cattr_accessor :requires_name
    self.requires_name = false

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

    # Returns the full name of the card holder.
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

    def valid_email?
      @email =~ EmailAddress
    end

    def valid_name?
      return false if self.class.requires_name && !name?
      return true
    end
  end
end
