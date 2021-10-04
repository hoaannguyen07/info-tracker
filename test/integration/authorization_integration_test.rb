require 'test_helper'

class AuthorizationIntegrationTest < ActionDispatch::IntegrationTest
  include Capybara::DSL
  include Capybara::Minitest::Assertions
  include Devise::Test::IntegrationHelpers

    setup do
        OmniAuth.config.test_mode = true
        Rails.application.env_config["devise.mapping"] = Devise.mappings[:user]
        Rails.application.env_config["omniauth.auth"]  = google_oauth2_mock
    end

    teardown do
        OmniAuth.config.test_mode = false
    end

    test "authorizes and sets user currently in database with Google OAuth" do
        visit root_path
        assert page.has_content? "Sign in with Google"  
        click_link "Sign in with Google"
        assert page.has_content? "Successfully authenticated from Google account."
    end

    private

        def google_oauth2_mock
            OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
            provider: "google_oauth2",
            uid: "12345678910",
            info: { 
                email: "realgmail@gmail.com",
                first_name: "Iron",
                last_name: "Man"
            },
            credentials: {
                token: "abcdefgh12345",
                refresh_token: "12345abcdefgh",
                expires_at: DateTime.now
            }
          })
        end

end