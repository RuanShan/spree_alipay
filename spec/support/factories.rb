require 'factory_girl'
require 'ffaker'
require 'spree/testing_support/factories'

FactoryGirl.find_definitions

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
end
