require 'spec_helper'

describe ActiveESP::Subscriber do
  before(:each) do
    @attributes = Factory.attributes_for(:subscriber)
  end
  
  it "should properly assign attributes" do
    subscriber = ActiveESP::Subscriber.new(@attributes)
    subscriber.first_name.should eq(@attributes[:first_name])
    subscriber.last_name.should eq(@attributes[:last_name])
    subscriber.email.should eq(@attributes[:email])
  end
end