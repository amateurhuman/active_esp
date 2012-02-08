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

  it "should assign the last word of a given full name as the last name" do
    subscriber = ActiveESP::Subscriber.new
    subscriber.name = "Some Really Long Name Morton"
    subscriber.last_name.should eq("Morton")
  end

  it "should assign the all words except the last of a given full name as the first name" do
    subscriber = ActiveESP::Subscriber.new
    subscriber.name = "Billie Joe Armstrong"
    subscriber.first_name.should eq("Billie Joe")
  end

end