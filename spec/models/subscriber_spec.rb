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

  it "should respond with the subscriber's full name" do
    subscriber = ActiveESP::Subscriber.new(:first_name => 'Kris', :last_name => 'Roe')
    subscriber.name.should eq('Kris Roe')
  end

  describe ".first_name?" do
    it "should return true if a first name has been assigned" do
      subscriber = ActiveESP::Subscriber.new(:first_name => 'Haushinka')
      subscriber.first_name?.should be_true
    end

    it "should return false if a first name has not been assigned" do
      subscriber = ActiveESP::Subscriber.new
      subscriber.first_name?.should be_false
    end

    it "should return false if the first name is blank" do
      subscriber = ActiveESP::Subscriber.new(:first_name => '')
      subscriber.first_name?.should be_false
    end
  end

  describe ".name=" do
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

end