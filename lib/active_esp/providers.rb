module ActiveESP
  module Providers
    # Thanks to ActiveMerchant for this autoloading code!
    Dir[File.dirname(__FILE__) + '/providers/*.rb'].each do |f|
      # Get camelized class name 
      filename = File.basename(f, '.rb')
      
      # Camelize the string to get the class name
      gateway_class = filename.camelize.to_sym
            
      # Register for autoloading
      autoload gateway_class, f      
    end

    class CouldNotSubscribeToListException < Exception; end
    class CouldNotUnsubscribeFromListException < Exception; end
  end
end