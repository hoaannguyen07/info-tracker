# frozen_string_literal: true

# location: spec/feature/events_integration_spec.rb
require 'rails_helper'
require 'selenium-webdriver'

RSpec.describe('Events Features', type: :feature) do
  before do
    Rails.application.env_config['devise.mapping'] = Devise.mappings[:admin]
    Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:google_user]
    Permission.create!(description: 'admin') if Permission.where(description: 'admin').first.nil?
    unless Admin.where(email: 'admindoe@example.com').first.nil? == false
      Admin.create!(email: 'admindoe@example.com', full_name: 'Admin Doe', uid: '234567890', avatar_url: 'https://lh3.googleusercontent.com/url/photo.jpg')
    end
  end

  def sign_in
    visit(root_path)
    # sign in and verify sign in
    click_on('Get Started!')

    # start with fresh event database on every run
    Event.delete_all
    visit(root_path)
  end

  def make_admin
    user_id = Admin.where(email: 'admindoe@example.com').first.id
    admin_permission_id = Permission.where(description: 'admin').first.id
    if PermissionUser.where(user_id_id: user_id, permissions_id_id: admin_permission_id).first.nil?
      PermissionUser.create!(user_id_id: user_id, permissions_id_id: admin_permission_id, created_by_id: user_id, updated_by_id: user_id)
    end
  end

  def create_valid_event
    click_on('New Event')
    fill_in('event[name]', with: 'Tournament')
    fill_in('event[description]', with: 'Gig Em')
    fill_in('event[location]', with: 'Texas A&M')
    fill_in('event[time]', with: '2021-10-18 23:38:00')
    click_on('Submit')

    Event.where(name: 'Tournament', description: 'Gig Em', location: 'Texas A&M',
                time: '2021-10-18 23:38:00'
    ).first
  end

  def edit_event(event_id)
    find("#edit-event-#{event_id}").click
  end

  def delete_event(event_id)
    find("#delete-event-#{event_id}").click
  end

  def fill_in_form(name, description, location, time)
    fill_in('event[name]', with: name)
    fill_in('event[description]', with: description)
    fill_in('event[location]', with: location)
    fill_in('event[time]', with: time)
  end

  it 'is at root page after login' do
    sign_in
    expect(page).to(have_current_path(root_path))
    expect(page).to(have_content('Players'))
    expect(page).to(have_selector(:link_or_button, 'New Player'))
  end

  it 'is able to go to events#index page and have correct event contents' do
    Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:google_admin]
    make_admin
    sign_in
    visit events_path
    expect(page).to(have_current_path(events_path))
    expect(page).to(have_content('Events'))
    expect(page).to(have_selector(:link_or_button, 'New Event'))
  end

  describe('#new feature') do
    it 'is able to go to #new' do
      Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:google_admin]
      make_admin
      sign_in
      visit events_path
      expect(page).to(have_selector(:link_or_button, 'New Event'))
      click_on 'New Event'
      expect(page).to(have_current_path(new_event_path))
    end

    it 'is NOT able to go to #new if NOT an admin' do
      sign_in
      visit events_path
      expect(page).not_to(have_selector(:link_or_button, 'New Event'))
    end

    context('when creating a event is successful') do
      it 'new event has valid attributes' do
        Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:google_admin]
        make_admin
        sign_in
        visit events_path
        click_on 'New Event'
        fill_in_form('Tournament', 'Gig Em', 'Texas A&M',
                     '2021-10-18 23:38:00'
        )
        click_on 'Submit'

        visit events_path
        expect(page).to(have_content('Tournament'))
      end

      it 'new event allows description and location to have special characters' do
        Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:google_admin]
        make_admin
        sign_in
        visit events_path
        click_on 'New Event'
        str = "`~1!2@3#4$5%6^7&8*9(0)-_=+qQwWeErRtTyYuUiIoOpP[{]}\|aAsSdDfFgGhHjJkKlL;:'\"zZxXcCvVbBnNmM,<.>/? \n\t "
        fill_in_form('Bossman', str, str, '2021-10-18 23:38:00')
        click_on 'Submit'

        visit events_path
        expect(page).to(have_content('Bossman'))
      end
    end

    context('when creating a event is unsuccessful') do
      it 'new event has invalid attributes' do
        Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:google_admin]
        make_admin
        sign_in
        visit events_path
        click_on 'New Event'
        fill_in_form('', 'Bossman', '-1', '')
        click_on 'Submit'

        visit events_path
        expect(page).not_to(have_content('Bossman'))
      end

      it 'new event has blank name' do
        Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:google_admin]
        make_admin
        sign_in
        visit events_path
        click_on 'New Event'
        fill_in_form('', 'Bossman', '10', '')
        click_on 'Submit'

        # verify expected error messages
        expect(page).to(have_content("Name can't be blank"))

        visit events_path
        expect(page).not_to(have_content('Bossman'))
        expect(page).not_to(have_content('10'))
      end

      it 'new event has blank time' do
        Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:google_admin]
        make_admin
        sign_in
        visit events_path
        click_on 'New Event'
        fill_in_form('', 'Bossman', '10', '')
        click_on 'Submit'

        # verify expected error messages
        expect(page).to(have_content("Time can't be blank"))

        visit events_path
        expect(page).not_to(have_content('Bossman'))
        expect(page).not_to(have_content('10'))
      end
    end
  end

  describe('#edit feature') do
    it 'is able to edit a event' do
      Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:google_admin]
      make_admin
      sign_in
      visit events_path
      created_event = create_valid_event

      visit events_path

      edit_event(created_event.id)

      expect(page).to(have_selector(:link_or_button, 'Submit'))
      expect(page).to(have_content("Editing #{created_event.name}"))
    end

    context('when editing a event is successful') do
      it 'updated event has valid attributes' do
        Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:google_admin]
        make_admin
        sign_in
        visit events_path
        created_event = create_valid_event

        visit events_path
        edit_event(created_event.id)
        fill_in_form('Bossman', '91', '81', '2021-10-18 23:38:00')
        click_on 'Submit'

        visit events_path
        expect(page).to(have_content('Bossman'))
        expect(page).to(have_content('81'))
        expect(page).not_to(have_content('Tournament'))
        expect(page).not_to(have_content('Texas A&M'))

        visit event_path(created_event.id)
        expect(page).to(have_content('91'))
        expect(page).not_to(have_content('Gig Em'))
      end
    end

    context('when editing a event is unsuccessful') do
      it 'updated event has invalid attributes' do
        Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:google_admin]
        make_admin
        sign_in
        visit events_path
        created_event = create_valid_event

        visit events_path
        edit_event(created_event.id)
        fill_in_form('', 'hacky', '-3', '')
        click_on 'Submit'

        visit events_path
        expect(page).to(have_content('Tournament'))
        expect(page).to(have_content('Texas A&M'))

        visit event_path(created_event.id)
        expect(page).not_to(have_content('hacky'))
        expect(page).to(have_content('Gig Em'))
      end
    end
  end

  describe('#delete feature') do
    it 'is able to delete a event' do
      Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:google_admin]
      make_admin
      sign_in
      visit events_path
      created_event = create_valid_event

      visit events_path
      delete_event(created_event.id)

      # alert = page.driver.browser.switch_to.alert.accept
      # expect(page.driver.browser.switch_to.alert).to include('Are you sure?')
      begin
        page.driver.browser.switch_to.alert.accept
      rescue StandardError
        Selenium::WebDriver::Error::NoSuchAlertError
      end

      expect(page).not_to(have_content(created_event.name))
    end
  end
end
