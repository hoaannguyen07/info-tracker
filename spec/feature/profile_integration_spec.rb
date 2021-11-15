# frozen_string_literal: true

# location: spec/feature/profile_integration_spec.rb

require 'rails_helper'
require 'selenium-webdriver'

RSpec.describe('Profile Features', type: :feature) do
  before do
    Rails.application.env_config['devise.mapping'] = Devise.mappings[:admin]
    Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:google_user]
    Permission.create!(description: 'admin') if Permission.where(description: 'admin').first.nil?
    unless Admin.where(email: 'userdoe@example.com').first.nil? == false
      Admin.create!(email: 'userdoe@example.com', full_name: 'User Doe', uid: '123456789', avatar_url: 'https://lh3.googleusercontent.com/url/photo.jpg')
    end
    visit root_path
    # sign in and verify sign in
    click_on 'Get Started!'

    # start with fresh player database on every run
    Player.delete_all
    visit profiles_home_path
  end

  it 'is at user profile' do
    expect(page).to(have_current_path(profiles_home_path))
    expect(page).to(have_content('User Profile'))
    expect(page).to(have_selector(:link_or_button, 'edit-profile'))
  end

  describe('view feature') do
    it 'is able to see profile information' do
      expect(page).to(have_content('Name: User Doe'))
      expect(page).to(have_content('Email: userdoe@example.com'))
    end
  end

  describe('edit feature') do
    context('when editing a profile is successful') do
      it 'is able to edit a profile' do
        find('#edit-profile').click
        fill_in('full_name', with: 'Jon Andy')
        expect(page).to(have_selector(:link_or_button, 'Submit'))
        click_on('Submit')
        expect(page).to(have_content('Name: Jon Andy'))
      end
    end

    context('when editing a profile is un-successful') do
      it 'is not able to edit a profile' do
        find('#edit-profile').click
        fill_in('full_name', with: nil)
        expect(page).to(have_selector(:link_or_button, 'Submit'))
        click_on('Submit')
        expect(page).to(have_content("Full name can't be blank"))
      end

      it 'is the same full name as before' do
        find('#edit-profile').click
        fill_in('full_name', with: nil)
        expect(page).to(have_selector(:link_or_button, 'Submit'))
        click_on('Back')
        expect(page).to(have_content('Name: User Doe'))
      end
    end
  end
end
