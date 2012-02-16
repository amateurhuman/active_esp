require 'spec_helper'

describe ActiveESP::Providers::MailChimp do
  it { should implement_interface(ActiveESP::Providers::Interface) }
end