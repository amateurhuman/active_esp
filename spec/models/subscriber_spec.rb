require 'spec_helper'

describe ActiveESP::Subscriber do
  before(:each) do
    ActiveESP::Subscriber.requires_name = false
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

  describe ".last_name?" do
    it "should return true if a last name has been assigned" do
      subscriber = ActiveESP::Subscriber.new(:last_name => 'Haushinka')
      subscriber.last_name?.should be_true
    end

    it "should return false if a last name has not been assigned" do
      subscriber = ActiveESP::Subscriber.new
      subscriber.last_name?.should be_false
    end

    it "should return false if the last name is blank" do
      subscriber = ActiveESP::Subscriber.new(:last_name => '')
      subscriber.last_name?.should be_false
    end
  end

  describe ".name?" do
    it "should return true if a first name has been assigned" do
      subscriber = ActiveESP::Subscriber.new(:first_name => 'Haushinka')
      subscriber.name?.should be_true
    end

    it "should return true if a last name has been assigned" do
      subscriber = ActiveESP::Subscriber.new(:last_name => 'Haushinka')
      subscriber.name?.should be_true
    end

    it "should return false if neither a first name nor a last name has been assigned" do
      subscriber = ActiveESP::Subscriber.new
      subscriber.name?.should be_false
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

  describe ".valid_email?" do
    it "should return true if the assigned email is valid" do
      subscriber = ActiveESP::Subscriber.new(:email => 'user@example.com')
      subscriber.should be_valid_email
    end

    it "should return false if the assigned email is not valid" do
      subscriber = ActiveESP::Subscriber.new(:email => 'user')
      subscriber.should_not be_valid_email
    end
  end

  describe ".valid_name?" do
    it "should return true if the name isn't required" do
      ActiveESP::Subscriber.requires_name = false
      subscriber = ActiveESP::Subscriber.new
      subscriber.valid_name?.should be_true
    end

    it "should return true if the name is required and the name is present" do
      ActiveESP::Subscriber.requires_name = true
      subscriber = ActiveESP::Subscriber.new
      subscriber.stub(:name?).and_return(true)
      subscriber.valid_name?.should be_true
    end

    it "should return false if the name is required and the name isn't present" do
      ActiveESP::Subscriber.requires_name = true
      subscriber = ActiveESP::Subscriber.new
      subscriber.stub(:name?).and_return(false)
      subscriber.valid_name?.should_not be_true
    end
  end

  describe ".valid?" do
    it "should return true if the name and email address are valid" do
      subscriber = ActiveESP::Subscriber.new
      subscriber.stub(:valid_name?).and_return(true)
      subscriber.stub(:valid_email?).and_return(true)
      subscriber.valid?.should be_true
    end

    it "should return false if the name isn't valid" do
      subscriber = ActiveESP::Subscriber.new
      subscriber.stub(:valid_name?).and_return(false)
      subscriber.valid?.should_not be_true
    end

    it "should return false if the email isn't valid" do
      subscriber = ActiveESP::Subscriber.new
      subscriber.stub(:valid_email?).and_return(false)
      subscriber.valid?.should_not be_true
    end
  end

end