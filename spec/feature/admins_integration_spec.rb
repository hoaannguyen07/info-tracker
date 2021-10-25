# frozen_string_literal: true

# location: spec/feature/admins_integration_spec.rb
require 'rails_helper'

RSpec.describe('Authentication', type: :feature) do
  before do
    Rails.application.env_config['devise.mapping'] = Devise.mappings[:admin]
    Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:google_user]
  end

  it 'root page redirects to Sign in Page if not signed in' do
    visit root_path
    # verify redirection & the page content to be the sign in page
    expect(page).to(have_current_path(new_admin_session_path))
    expect(page).to(have_content('Welcome to the Table Tennis Opponent Tracker'))
    expect(page).to(have_selector(:link_or_button, 'Get Started!'))
  end

  it 'players#index redirects to Sign in Page if not signed in' do
    visit players_path
    # verify redirection & the page content to be the sign in page
    expect(page).to(have_current_path(new_admin_session_path))
    expect(page).to(have_content('Welcome to the Table Tennis Opponent Tracker'))
    expect(page).to(have_selector(:link_or_button, 'Get Started!'))
  end

  it 'players#new redirects to Sign in Page if not signed in' do
    visit new_player_path
    # verify redirection & the page content to be the sign in page
    expect(page).to(have_current_path(new_admin_session_path))
    expect(page).to(have_content('Welcome to the Table Tennis Opponent Tracker'))
    expect(page).to(have_selector(:link_or_button, 'Get Started!'))
  end

  it 'Sign in with valid credentials' do
    visit root_path

    # sign in and verify sign in
    click_on 'Get Started!'
    expect(page).to(have_content('Successfully authenticated from Google account.'))
  end

  it 'Sign in with valid credentials redirects to root path' do
    visit root_path

    # sign in and verify sign in
    click_on 'Get Started!'
    # root path is currently set to players#index, but that won't be part of the URL so can't compare to players_path
    expect(page).to(have_current_path(root_path || stored_location_for(resource_or_scope)))
  end

  it 'Sign out using nav bar redirects to login screen' do
    visit root_path

    # sign in and verify sign in
    click_on 'Get Started!'

    find('#sign-out-nav-bar').click
    expect(page).to(have_content('Signed out successfully.'))
  end

  it 'Sign out using nav bar redirects to new_admin_session_path' do
    visit root_path

    # sign in and verify sign in
    click_on 'Get Started!'

    find('#sign-out-nav-bar').click
    expect(page).to(have_current_path(new_admin_session_path))
  end

  it 'Sign out using side bar redirects to login screen' do
    visit root_path

    # sign in and verify sign in
    click_on 'Get Started!'

    find('#sign-out-side-bar').click
    expect(page).to(have_content('Signed out successfully.'))
  end

  it 'Sign out using side bar redirects to new_admin_session_path' do
    visit root_path

    # sign in and verify sign in
    click_on 'Get Started!'

    find('#sign-out-side-bar').click
    expect(page).to(have_current_path(new_admin_session_path))
  end
end
