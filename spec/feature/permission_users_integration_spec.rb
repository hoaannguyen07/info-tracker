# frozen_string_literal: true

require 'rails_helper'
require 'selenium-webdriver'

RSpec.describe('PermissionUsers Features', type: :feature) do
  before do
    Rails.application.env_config['devise.mapping'] = Devise.mappings[:admin]
    Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:google_user]
    Permission.create!(description: 'admin') if Permission.where(description: 'admin').first.nil?
    unless Admin.where(email: 'admindoe@example.com').first.nil? == false
      Admin.create!(email: 'admindoe@example.com', full_name: 'Admin Doe', uid: '234567890', avatar_url: 'https://lh3.googleusercontent.com/url/photo.jpg')
    end
    unless Admin.where(email: 'userdoe@example.com').first.nil? == false
      Admin.create!(email: 'userdoe@example.com', full_name: 'User Doe', uid: '123456789', avatar_url: 'https://lh3.googleusercontent.com/url/photo.jpg')
    end
  end

  def sign_in
    visit(root_path)
    # sign in and verify sign in
    click_on('Get Started!')

    # start with fresh event database on every run
    PermissionUser.delete_all
    visit(root_path)
  end

  def make_admin
    user_id = Admin.where(email: 'admindoe@example.com').first.id
    admin_permission_id = Permission.where(description: 'admin').first.id
    if PermissionUser.where(user_id_id: user_id, permissions_id_id: admin_permission_id).first.nil?
      PermissionUser.create!(user_id_id: user_id, permissions_id_id: admin_permission_id, created_by_id: user_id, updated_by_id: user_id)
    end
  end

  def create_valid_permission_users_record
    visit
  end

  it 'is at root page after login' do
    sign_in
    expect(page).to(have_current_path(root_path))
    expect(page).to(have_content('Players'))
    expect(page).to(have_selector(:link_or_button, 'New Player'))
  end

  it 'is able to go to permission_users page and have correct' do
    Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:google_admin]
    sign_in
    make_admin
    visit permission_users_path
    expect(page).to(have_current_path(permission_users_path))
    expect(page).to(have_content('Users'))
    expect(page).to(have_selector(:link_or_button), 'Add a New Permission')
  end

  it 'is NOT able to go to #new if NOT an admin' do
    Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:google_user]
    sign_in
    visit permission_users_path
    expect(page).not_to(have_content('Users'))
    expect(page).to(have_content('PERMISSION DENIED'))
  end

  describe('#new feature') do
    it 'is able to add permission to a given user as an admin' do
      Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:google_admin]
      sign_in
      make_admin
      visit permission_users_path
      admin_id = Admin.where(email: 'userdoe@example.com').first.id
      permission_id = Permission.where(description: 'admin').first.id
      expect(page).to(have_content('Users'))
      find("#add-permission-#{admin_id}-#{permission_id}").click
    end

    it 'is NOT able to add permission to a given user if user_id is invalid' do
      Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:google_admin]
      sign_in
      make_admin
      visit permission_users_path
      permission_id = Permission.where(description: 'admin').first.id
      expect(page).not_to(have_css("#add-permission-10000-#{permission_id}"))
    end

    it 'is NOT able to add permission to a given user if permission_id is invalid' do
      Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:google_admin]
      sign_in
      make_admin
      visit permission_users_path
      admin_id = Admin.where(email: 'userdoe@example.com').first.id
      expect(page).not_to(have_css("#add-permission-#{admin_id}-10000"))
    end

    it 'is NOT able to add permission to a given user if permission already exists' do
      Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:google_admin]
      sign_in
      make_admin
      visit permission_users_path
      admin_id = Admin.where(email: 'userdoe@example.com').first.id
      permission_id = Permission.where(description: 'admin').first.id
      expect(page).to(have_content('Users'))
      find("#add-permission-#{admin_id}-#{permission_id}").click

      expect(page).not_to(have_css("#add-permission-#{admin_id}-#{permission_id}"))
    end
  end
end
