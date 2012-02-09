require 'spec_helper'

describe ActiveESP::Provider::MailChimp do
  it { should implement_interface(ActiveESP::Provider::Interface) }
end