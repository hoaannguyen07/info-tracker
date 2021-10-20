# frozen_string_literal: true

# location: spec/feature/events_integration_spec.rb
require 'rails_helper'
require 'selenium-webdriver'

RSpec.describe('Players Features', type: :feature) do
  before do
    Rails.application.env_config['devise.mapping'] = Devise.mappings[:admin]
    Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:google]
    visit root_path
    # sign in and verify sign in
    click_on 'Get Started!'

    # start with fresh player database on every run
    Player.delete_all
    visit events_path
  end
end
