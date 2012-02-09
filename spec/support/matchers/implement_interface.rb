RSpec::Matchers.define :implement_interface do |expected|
  match do |object|
    @unimplemented_methods = object.unimplemented_methods.reject do |interface, methods|
      interface != expected
    end

    @unimplemented_methods.empty?
  end

  failure_message_for_should do |actual|
    "did not implement #{@unimplemented_methods.inspect}"
  end
end