# frozen_string_literal: true

require 'rails_helper'
require 'selenium-webdriver'
Rails.root.join('fixtures/files/')

RSpec.describe('Images Feautures', type: :feature) do
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
    Image.delete_all
    visit(images_path)
  end

  def make_admin
    user_id = Admin.where(email: 'admindoe@example.com').first.id
    admin_permission_id = Permission.where(description: 'admin').first.id
    unless PermissionUser.where(user_id_id: user_id, permissions_id_id: admin_permission_id).first.nil? == false
      PermissionUser.create!(user_id_id: user_id, permissions_id_id: admin_permission_id, created_by_id: user_id, updated_by_id: user_id)
    end
  end

  def upload_image
    click_on('New Image')
    attach_file('image[img]', Rails.root.join('spec/fixtures/files/good.png'))
    fill_in('image[caption]', with: 'A Test Caption')
    click_on('Submit')
    visit(images_path)
  end

  def upload_get_image
    click_on('New Image')
    attach_file('image[img]', Rails.root.join('spec/fixtures/files/good.png'))
    fill_in('image[caption]', with: 'A Test Caption')
    click_on('Submit')

    Image.where(
      caption: 'A Test Caption'
    ).first
  end

  describe('#new feature') do
    it 'is able to go to #new' do
      Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:google_admin]
      make_admin
      sign_in
      expect(page).to(have_selector(:link_or_button, 'New Image'))
      click_on 'New Image'
      expect(page).to(have_current_path(new_image_path))
    end

    it 'is NOT able to go to #new if NOT an admin' do
      sign_in
      expect(page).not_to(have_selector(:link_or_button, 'New Image'))
    end

    context('when creating an image is successful') do
      it 'new image has valid attributes with png' do
        Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:google_admin]
        make_admin
        sign_in
        click_on 'New Image'
        attach_file('image[img]', Rails.root.join('spec/fixtures/files/good.png'))
        fill_in('image[caption]', with: 'A Test Caption')
        click_on 'Submit'
        visit images_path
        expect(page).to(have_css("img[src$='good.png']"))
      end

      it 'new image has valid attributes with jpg' do
        Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:google_admin]
        make_admin
        sign_in
        click_on 'New Image'
        attach_file('image[img]', Rails.root.join('spec/fixtures/files/computer.jpg'))
        fill_in('image[caption]', with: 'A Test Caption')
        click_on 'Submit'

        visit images_path
        expect(page).to(have_css("img[src$='computer.jpg']"))
      end

      it 'new image has valid attributes with jpeg' do
        Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:google_admin]
        make_admin
        sign_in
        click_on 'New Image'
        attach_file('image[img]', Rails.root.join('spec/fixtures/files/flower.jpeg'))
        fill_in('image[caption]', with: 'A Test Caption')
        click_on 'Submit'

        visit images_path
        expect(page).to(have_css("img[src$='flower.jpeg']"))
      end
    end

    context('when creating an image is unsuccessful') do
      it 'new image has invalid attributes with pdf' do
        Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:google_admin]
        make_admin
        sign_in
        click_on 'New Image'
        attach_file('image[img]', Rails.root.join('spec/fixtures/files/bad.pdf'))
        fill_in('image[caption]', with: 'A Test Caption')
        click_on 'Submit'
        expect(page).to(have_current_path(images_path))
      end

      it 'new image has invalid attributes with no caption and png' do
        Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:google_admin]
        make_admin
        sign_in
        click_on 'New Image'
        attach_file('image[img]', Rails.root.join('spec/fixtures/files/good.png'))
        fill_in('image[caption]', with: nil)
        click_on 'Submit'
        expect(page).to(have_current_path(images_path))
      end

      it 'new image has invalid attributes with no caption and jpg' do
        Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:google_admin]
        make_admin
        sign_in
        click_on 'New Image'
        attach_file('image[img]', Rails.root.join('spec/fixtures/files/computer.jpg'))
        fill_in('image[caption]', with: nil)
        click_on 'Submit'
        expect(page).to(have_current_path(images_path))
      end

      it 'new image has invalid attributes with no caption and jpeg' do
        Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:google_admin]
        make_admin
        sign_in
        click_on 'New Image'
        attach_file('image[img]', Rails.root.join('spec/fixtures/files/flower.jpeg'))
        fill_in('image[caption]', with: nil)
        click_on 'Submit'
        expect(page).to(have_current_path(images_path))
      end

      it 'new image has invalid attributes with too long of caption and png' do
        Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:google_admin]
        make_admin
        sign_in
        click_on 'New Image'
        attach_file('image[img]', Rails.root.join('spec/fixtures/files/good.png'))
        fill_in('image[caption]', with: 'a' * 257)
        click_on 'Submit'
        expect(page).to(have_current_path(images_path))
      end

      it 'new image has invalid attributes with too long of caption and jpg' do
        Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:google_admin]
        make_admin
        sign_in
        click_on 'New Image'
        attach_file('image[img]', Rails.root.join('spec/fixtures/files/computer.jpg'))
        fill_in('image[caption]', with: 'a' * 257)
        click_on 'Submit'
        expect(page).to(have_current_path(images_path))
      end

      it 'new image has invalid attributes with too long of caption and jpeg' do
        Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:google_admin]
        make_admin
        sign_in
        click_on 'New Image'
        attach_file('image[img]', Rails.root.join('spec/fixtures/files/flower.jpeg'))
        fill_in('image[caption]', with: 'a' * 257)
        click_on 'Submit'
        expect(page).to(have_current_path(images_path))
      end

      it 'new image has invalid attributes with pdf and no caption' do
        Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:google_admin]
        make_admin
        sign_in
        click_on 'New Image'
        attach_file('image[img]', Rails.root.join('spec/fixtures/files/bad.pdf'))
        fill_in('image[caption]', with: nil)
        click_on 'Submit'
        expect(page).to(have_current_path(images_path))
      end

      it 'new image has invalid attributes with no image' do
        Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:google_admin]
        make_admin
        sign_in
        click_on 'New Image'
        fill_in('image[caption]', with: 'A Test Caption')
        click_on 'Submit'
        expect(page).to(have_current_path(images_path))
      end

      it 'new image has invalid attributes with no image and too long of caption' do
        Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:google_admin]
        make_admin
        sign_in
        click_on 'New Image'
        fill_in('image[caption]', with: 'a' * 257)
        click_on 'Submit'
        expect(page).to(have_current_path(images_path))
      end

      it 'new image has invalid attributes with no image and missing caption' do
        Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:google_admin]
        make_admin
        sign_in
        click_on 'New Image'
        fill_in('image[caption]', with: nil)
        click_on 'Submit'
        expect(page).to(have_current_path(images_path))
      end
    end
  end

  describe('#show feature') do
    it 'is able to go to #show' do
      Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:google_admin]
      make_admin
      sign_in
      image = upload_get_image
      visit images_path
      click_on(id: "image-#{image.id}")
      expect(page).to(have_current_path(image_path(image.id)))
    end

    it 'show image source matches image source from index' do
      Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:google_admin]
      make_admin
      sign_in
      upload_image
      find("img[src*='good.png']").click
      expect(page).to(have_css("img[src$='good.png']"))
    end
  end

  describe('#edit feature') do
    it 'is able to go to #edit' do
      Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:google_admin]
      make_admin
      sign_in
      image = upload_get_image
      visit images_path
      click_on(id: "image-#{image.id}")
      expect(page).to(have_selector(:link_or_button, 'Edit'))
      click_on('Edit')
      expect(page).to(have_content('Update Image'))
    end

    context('when editing an image is successful') do
      it 'is able to edit an image' do
        Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:google_admin]
        make_admin
        sign_in
        image = upload_get_image
        visit images_path
        click_on(id: "image-#{image.id}")
        expect(page).to(have_selector(:link_or_button, 'Edit'))
        click_on('Edit')
        fill_in('image[caption]', with: 'A Different Test Caption')
        click_on('Submit')
        expect(page).to(have_content('A Different Test Caption'))
      end
    end

    context('when editing an image is unsuccessful') do
      it 'is not able to update with too long of caption' do
        Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:google_admin]
        make_admin
        sign_in
        image = upload_get_image
        visit images_path
        click_on(id: "image-#{image.id}")
        expect(page).to(have_selector(:link_or_button, 'Edit'))
        click_on('Edit')
        fill_in('image[caption]', with: 'a' * 257)
        click_on('Submit')
        expect(page).to(have_content('Caption is too long (maximum is 256 characters)'))
      end

      it 'is not able to update with no caption' do
        Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:google_admin]
        make_admin
        sign_in
        image = upload_get_image
        visit images_path
        click_on(id: "image-#{image.id}")
        expect(page).to(have_selector(:link_or_button, 'Edit'))
        click_on('Edit')
        fill_in('image[caption]', with: nil)
        click_on('Submit')
        expect(page).to(have_content("Caption can't be blank"))
      end
    end
  end
end
