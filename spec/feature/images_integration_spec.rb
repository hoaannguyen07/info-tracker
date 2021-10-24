# frozen_string_literal: true

require 'rails_helper'
require 'selenium-webdriver'
Rails.root.join('fixtures/files/')

RSpec.describe('Images Feautures', type: :feature) do
  before do
    Rails.application.env_config['devise.mapping'] = Devise.mappings[:admin]
    Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:google]
    visit root_path
    # sign in and verify sign in
    click_on 'Get Started!'

    # start with fresh player database on every run
    Player.delete_all
    visit images_path
  end

  describe('#new feature') do
    it 'is able to go to #new' do
      expect(page).to(have_selector(:link_or_button, 'New Image'))
      click_on 'New Image'
      expect(page).to(have_current_path(new_image_path))
    end

    context('when creating an image is successful') do
      it 'new image has valid attributes with png' do
        click_on 'New Image'
        attach_file('image[img]', Rails.root.join('spec/fixtures/files/good.png'))
        fill_in('image[caption]', with: 'A Test Caption')
        click_on 'Submit'

        visit images_path
        expect(page).to(have_css("img[src$='good.png']"))
      end

      it 'new image has valid attributes with jpg' do
        click_on 'New Image'
        attach_file('image[img]', Rails.root.join('spec/fixtures/files/computer.jpg'))
        fill_in('image[caption]', with: 'A Test Caption')
        click_on 'Submit'

        visit images_path
        expect(page).to(have_css("img[src$='computer.jpg']"))
      end

      it 'new image has valid attributes with jpeg' do
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
        click_on 'New Image'
        attach_file('image[img]', Rails.root.join('spec/fixtures/files/bad.pdf'))
        fill_in('image[caption]', with: 'A Test Caption')
        click_on 'Submit'
        expect(page).to(have_current_path(images_path))
      end

      it 'new image has invalid attributes with no caption and png' do
        click_on 'New Image'
        attach_file('image[img]', Rails.root.join('spec/fixtures/files/good.png'))
        fill_in('image[caption]', with: nil)
        click_on 'Submit'
        expect(page).to(have_current_path(images_path))
      end

      it 'new image has invalid attributes with no caption and jpg' do
        click_on 'New Image'
        attach_file('image[img]', Rails.root.join('spec/fixtures/files/computer.jpg'))
        fill_in('image[caption]', with: nil)
        click_on 'Submit'
        expect(page).to(have_current_path(images_path))
      end

      it 'new image has invalid attributes with no caption and jpeg' do
        click_on 'New Image'
        attach_file('image[img]', Rails.root.join('spec/fixtures/files/flower.jpeg'))
        fill_in('image[caption]', with: nil)
        click_on 'Submit'
        expect(page).to(have_current_path(images_path))
      end

      it 'new image has invalid attributes with too long of caption and png' do
        click_on 'New Image'
        attach_file('image[img]', Rails.root.join('spec/fixtures/files/good.png'))
        fill_in('image[caption]', with: 'a' * 257)
        click_on 'Submit'
        expect(page).to(have_current_path(images_path))
      end

      it 'new image has invalid attributes with too long of caption and jpg' do
        click_on 'New Image'
        attach_file('image[img]', Rails.root.join('spec/fixtures/files/computer.jpg'))
        fill_in('image[caption]', with: 'a' * 257)
        click_on 'Submit'
        expect(page).to(have_current_path(images_path))
      end

      it 'new image has invalid attributes with too long of caption and jpeg' do
        click_on 'New Image'
        attach_file('image[img]', Rails.root.join('spec/fixtures/files/flower.jpeg'))
        fill_in('image[caption]', with: 'a' * 257)
        click_on 'Submit'
        expect(page).to(have_current_path(images_path))
      end

      it 'new image has invalid attributes with pdf and no caption' do
        click_on 'New Image'
        attach_file('image[img]', Rails.root.join('spec/fixtures/files/bad.pdf'))
        fill_in('image[caption]', with: nil)
        click_on 'Submit'
        expect(page).to(have_current_path(images_path))
      end

      it 'new image has invalid attributes with no image' do
        click_on 'New Image'
        fill_in('image[caption]', with: 'A Test Caption')
        click_on 'Submit'
        expect(page).to(have_current_path(images_path))
      end

      it 'new image has invalid attributes with no image and too long of caption' do
        click_on 'New Image'
        fill_in('image[caption]', with: 'a' * 257)
        click_on 'Submit'
        expect(page).to(have_current_path(images_path))
      end

      it 'new image has invalid attributes with no image and missing caption' do
        click_on 'New Image'
        fill_in('image[caption]', with: nil)
        click_on 'Submit'
        expect(page).to(have_current_path(images_path))
      end
    end
  end
end
