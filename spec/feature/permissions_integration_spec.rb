# frozen_string_literal: true

require 'rails_helper'
require 'selenium-webdriver'

RSpec.describe('Permissions Features', type: :feature) do
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
    Permission.where.not(description: 'admin').delete_all
    visit(root_path)
  end

  def make_admin
    user_id = Admin.where(email: 'admindoe@example.com').first.id
    admin_permission_id = Permission.where(description: 'admin').first.id
    if PermissionUser.where(user_id_id: user_id, permissions_id_id: admin_permission_id).first.nil?
      PermissionUser.create!(user_id_id: user_id, permissions_id_id: admin_permission_id, created_by_id: user_id, updated_by_id: user_id)
    end
  end

  def create_valid_permission
    click_on('Add a New Permission')
    fill_in('permission[description]', with: 'testing')
    click_on('Submit')

    Permission.where(description: 'testing').first
  end

  def edit_permission(permission_id)
    find("#edit-permission-#{permission_id}").click
  end

  def delete_permission(permission_id)
    find("#delete-permission-#{permission_id}").click
  end

  it 'is at root page after login' do
    sign_in
    expect(page).to(have_current_path(root_path))
    expect(page).to(have_content('Players'))
    expect(page).to(have_selector(:link_or_button, 'New Player'))
  end

  it 'is able to go to permissions page and have correct permissions page' do
    Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:google_admin]
    sign_in
    make_admin
    visit permission_users_path
    expect(page).to(have_current_path(permission_users_path))
    expect(page).to(have_content('Users'))
    expect(page).to(have_selector(:link_or_button), 'Add a New Permission')
    click_on 'Add a New Permission'
    expect(page).to(have_content('Permissions'))
    expect(page).to(have_selector(:link_or_button), 'Add a New Permission')
  end

  it 'is NOT able to go to #new if NOT an admin' do
    Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:google_user]
    sign_in
    visit permission_users_path
    expect(page).not_to(have_content('Users'))
    expect(page).to(have_content('You are not an admin! Better luck next time!'))
  end

  describe('#new feature') do
    it 'is able to go to #new' do
      Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:google_admin]
      make_admin
      sign_in
      visit permissions_path
      expect(page).to(have_selector(:link_or_button, 'Add a New Permission'))
      click_on 'Add a New Permission'
      expect(page).to(have_current_path(new_permission_path))
    end

    it 'is NOT able to go to #new if NOT an admin' do
      sign_in
      visit permission_users_path
      expect(page).not_to(have_selector(:link_or_button, 'Add a New Permission'))
    end

    context('when creating an event is successful') do
      it 'new permission has valid attributes' do
        Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:google_admin]
        make_admin
        sign_in
        visit permissions_path
        click_on 'Add a New Permission'
        fill_in('permission[description]', with: 'testing')
        click_on 'Submit'

        visit permissions_path
        expect(page).to(have_content('testing'))
      end

      it 'new permissions allows description to have dash or underscore' do
        Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:google_admin]
        make_admin
        sign_in
        visit permissions_path
        click_on 'Add a New Permission'
        fill_in('permission[description]', with: 'testing-test')
        click_on 'Submit'

        visit permissions_path
        expect(page).to(have_content('testing-test'))
      end
    end

    context('when creating a permission is unsuccessful') do
      it 'new permission has invalid attributes' do
        Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:google_admin]
        make_admin
        sign_in
        visit permissions_path
        click_on 'Add a New Permission'
        fill_in('permission[description]', with: "`~1!2@3#4$5%6^7&8*9(0)-_=+qQwWeErRtTyYuUiIoOpP[{]}\|aAsSdDfFgGhHjJkKlL;:'\"zZxXcCvVbBnNmM,<.>/? \n\t ")
        click_on 'Submit'

        visit permissions_path
        expect(page).not_to(have_content("`~1!2@3#4$5%6^7&8*9(0)-_=+qQwWeErRtTyYuUiIoOpP[{]}\|aAsSdDfFgGhHjJkKlL;:'\"zZxXcCvVbBnNmM,<.>/? \n\t "))
      end

      it 'new permission has blank description' do
        Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:google_admin]
        make_admin
        sign_in
        visit permissions_path
        click_on 'Add a New Permission'
        click_on 'Submit'

        expect(page).to(have_content("Description can't be blank"))
      end
    end
  end

  describe('#edit permission') do
    it 'is able to edit a permission' do
      Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:google_admin]
      make_admin
      sign_in
      visit permissions_path
      created_permission = create_valid_permission

      visit permissions_path

      edit_permission(created_permission.id)

      expect(page).to(have_selector(:link_or_button, 'Submit'))
      expect(page).to(have_content("Editing #{created_permission.description}"))
    end

    context('when editing an event is successful') do
      it 'updated permission has valid attributes' do
        Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:google_admin]
        make_admin
        sign_in
        visit permissions_path
        created_permission = create_valid_permission

        visit permissions_path
        edit_permission(created_permission.id)
        fill_in('permission[description]', with: 'testing-again')
        click_on 'Submit'

        visit permissions_path
        expect(page).to(have_content('testing-again'))

        visit permissions_path(created_permission.id)
        expect(page).to(have_content('testing-again'))
      end
    end

    context('when editing an permission is unsuccessful') do
      it 'updated permission has invalid attributes' do
        Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:google_admin]
        make_admin
        sign_in
        visit permissions_path
        created_permission = create_valid_permission

        visit permissions_path
        edit_permission(created_permission.id)
        fill_in('permission[description]', with: 'testing%$#%again')
        click_on 'Submit'
        expect(page).to(have_content("Description cannot use any special characters other than spaces, '-' (dashes), or '_' (underscores)"))
        visit permissions_path
      end
    end
  end

  describe('#delete feature') do
    it 'is able to delete a feature' do
      Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:google_admin]
      make_admin
      sign_in
      visit permissions_path
      created_permission = create_valid_permission

      visit permissions_path
      delete_permission(created_permission.id)

      # alert = page.driver.browser.switch_to.alert.accept
      # expect(page.driver.browser.switch_to.alert).to include('Are you sure?')
      begin
        page.driver.browser.switch_to.alert.accept
      rescue StandardError
        Selenium::WebDriver::Error::NoSuchAlertError
      end

      expect(page).not_to(have_content(created_permission.description))
    end
  end
end
