# location: spec/feature/integration_spec.rb
require 'rails_helper'

RSpec.describe 'Visiting', type: :feature do
    before do
        Rails.application.env_config["devise.mapping"] = Devise.mappings[:admin] # If using Devise
        Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:google]
    end

    scenario 'root page without signing in beforehand' do
        visit root_path
        # verify redirection & the page content to be the sign in page
        expect(page).to have_current_path('/admins/sign_in')
        expect(page).to have_content('Sign in with Google')
    end

    scenario 'players#index page without signing in beforehand' do
        visit players_path
        # verify redirection & the page content to be the sign in page
        expect(page).to have_current_path('/admins/sign_in')
        expect(page).to have_content('Sign in with Google')
    end

    scenario 'players#new page without signing in beforehand' do
        visit new_player_path
        # verify redirection & the page content to be the sign in page
        expect(page).to have_current_path('/admins/sign_in')
        expect(page).to have_content('Sign in with Google')
    end

    scenario 'page and signing in with Google' do
        visit root_path
        # verify redirection & the page content to be the sign in page
        expect(page).to have_current_path('/admins/sign_in')
        expect(page).to have_content('Sign in with Google')
        # request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:google] 
        click_on 'Sign in with Google'
        expect(page).to have_content ('Sign Out')
        expect(page).to have_content ('Players')
    end

    # scenario 'while signing in beforehand' do
    #     visit players_path
    #     click_on 'Sign in with Google'
    #     fill_in 'identifier', with: 'hoaannguyen07@tamu.edu'
    #     click_on 'Next'
    #     fill_in 'password', with: '#Hoa31801*'
    #     click_on 'Next'
    #     expect(page).to have_content('Players')
    #     expect(page).to have_current_path(root_path)
    # end
end