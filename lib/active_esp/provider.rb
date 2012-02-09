module ActiveESP
  module Provider
    # Thanks to ActiveMerchant for this autoloading code!
    Dir[File.dirname(__FILE__) + '/provider/*.rb'].each do |f|
      # Get camelized class name 
      filename = File.basename(f, '.rb')
      
      # Camelize the string to get the class name
      gateway_class = filename.camelize.to_sym
            
      # Register for autoloading
      autoload gateway_class, f      
    end
  end
end