ENV['RAILS_ENV'] ||= 'test'
require_relative "../config/environment"
require "rails/test_help"
# require 'mocha/minitest'

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def setup_omniauth_mock(user)
    OmniAuth.config.test_mode = true
      OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
        provider: "google_oauth2",
        email: "#{user.email}",
        first_name: "#{user.first_name}",
        last_name: "#{user.last_name}"
      })
      Rails.application.env_config["devise.mapping"] = Devise.mappings[:user]
    Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:google_oauth2]
  end

  def login_with_user(user)
    setup_omniauth_mock(user)
    get user_google_oauth2_omniauth_authorize_path
  end

end

module ActionController
    class TestCase
        include Devise::Test::ControllerHelpers
    end
end

module ActionDispatch
    class IntegrationTest
        include Devise::Test::IntegrationHelpers
    end
end
