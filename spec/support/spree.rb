require 'spree/testing_support/controller_requests'
require 'spree/testing_support/authorization_helpers'
require 'spree/testing_support/url_helpers'
require 'spree/testing_support/capybara_ext'
require 'spree/testing_support/preferences'

RSpec.configure do |config|
  config.include Spree::TestingSupport::ControllerRequests, type: :controller
  config.include FactoryGirl::Syntax::Methods
  config.include Spree::TestingSupport::UrlHelpers
  config.include Spree::TestingSupport::Preferences
  config.extend Spree::TestingSupport::AuthorizationHelpers::Request, type: :feature
end
