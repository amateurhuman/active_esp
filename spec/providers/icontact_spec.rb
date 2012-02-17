require 'spec_helper'

describe ActiveESP::Providers::IContact do
  it { should implement_interface(ActiveESP::Providers::Interface) }
end