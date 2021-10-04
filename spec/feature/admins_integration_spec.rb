# location: spec/feature/admins_integration_spec.rb
require 'rails_helper'

RSpec.describe 'Authentication', type: :feature do
    before do
        Rails.application.env_config["devise.mapping"] = Devise.mappings[:admin] # If using Devise
        Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:google]
    end

    scenario 'root page redirects to Sign in Page if not signed in' do
        visit root_path
        # verify redirection & the page content to be the sign in page
        expect(page).to have_current_path('/admins/sign_in')
        expect(page).to have_content('Welcome to the Table Tennis Opponent Tracker')
        expect(page).to have_selector(:link_or_button, 'Get Started!')
    end

    scenario 'players#index redirects to Sign in Page if not signed in' do
        visit players_path
        # verify redirection & the page content to be the sign in page
        expect(page).to have_current_path('/admins/sign_in')
        expect(page).to have_content('Welcome to the Table Tennis Opponent Tracker')
        expect(page).to have_selector(:link_or_button, 'Get Started!')
    end

    scenario 'players#new redirects to Sign in Page if not signed in' do
        visit new_player_path
        # verify redirection & the page content to be the sign in page
        expect(page).to have_current_path('/admins/sign_in')
        expect(page).to have_content('Welcome to the Table Tennis Opponent Tracker')
        expect(page).to have_selector(:link_or_button, 'Get Started!')
    end

    scenario 'Sign in with valid credentials' do
        visit root_path


        # sign in and verify sign in
        click_on 'Get Started!'
        expect(page).to have_content ('Successfully authenticated from Google account.')
    end

    scenario 'Sign in with valid credentials redirects to root path' do
        visit root_path

        # sign in and verify sign in
        click_on 'Get Started!'
        expect(page).to have_current_path(root_path) # root path is currently set to players#index, but that won't be part of the URL so can't compare to players_path
    end

    scenario 'Sign out redirects to login screen' do
        visit root_path

        # sign in and verify sign in
        click_on 'Get Started!'

        click_on 'Sign Out'
        expect(page).to have_content('Signed out successfully.')
    end
end