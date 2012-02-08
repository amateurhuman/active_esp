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
  end
end
