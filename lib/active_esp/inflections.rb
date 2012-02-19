ActiveSupport::Inflector.inflections do |inflect|
  inflect.acronym('IContact') if inflect.respond_to?(:acronym)
end