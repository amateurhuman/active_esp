require 'rubygems'
require 'bundler/setup'
require 'active_esp'
require 'factory_girl'
require './spec/factories'

Dir[File.dirname(__FILE__) + "/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  # some (optional) config here
end