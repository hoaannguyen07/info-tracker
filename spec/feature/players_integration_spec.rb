# frozen_string_literal: true

# location: spec/feature/players_integration_spec.rb
require 'rails_helper'
require 'selenium-webdriver'

RSpec.describe('Players Features', type: :feature) do
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
    visit root_path
  end

  def create_valid_player
    click_on('New Player')
    fill_in('player[name]', with: 'Jane Doe')
    fill_in('player[losses]', with: '25')
    fill_in('player[wins]', with: '10')
    fill_in('player[strengths]', with: "She has an amazing backhand that I can't beat")
    fill_in('player[weaknesses]', with: 'She cannot spin spin the ball very well')
    fill_in('player[additional_info]', with: 'She likes playing up-close to the table')
    click_on('Submit')

    Player.where(name: 'Jane Doe', losses: '25', wins: '10',
                 strengths: "She has an amazing backhand that I can't beat",
                 weaknesses: 'She cannot spin spin the ball very well',
                 additional_info: 'She likes playing up-close to the table'
    ).first
  end

  def edit_player(player_id)
    find("#edit-player-#{player_id}").click
  end

  def delete_player(player_id)
    find("#delete-player-#{player_id}").click
  end

  def fill_in_form(name, losses, wins, strengths, weaknesses, _additional_info)
    fill_in('player[name]', with: name)
    fill_in('player[losses]', with: losses)
    fill_in('player[wins]', with: wins)
    fill_in('player[strengths]', with: strengths)
    fill_in('player[weaknesses]', with: weaknesses)
    fill_in('player[additional_info]', with: weaknesses)
  end

  it 'is at root page after login' do
    expect(page).to(have_current_path(root_path))
    expect(page).to(have_content('Players'))
    expect(page).to(have_selector(:link_or_button, 'New Player'))
  end

  it 'is able to go to players#index page and have contents be the same as root page' do
    visit players_path
    expect(page).to(have_current_path(players_path))
    expect(page).to(have_content('Players'))
    expect(page).to(have_selector(:link_or_button, 'New Player'))
  end

  describe('#new feature') do
    it 'is able to go to #new' do
      expect(page).to(have_selector(:link_or_button, 'New Player'))
      click_on 'New Player'
      expect(page).to(have_current_path(new_player_path))
    end

    context('when creating a player is successful') do
      it 'new player has valid attributes' do
        click_on 'New Player'
        fill_in_form('Jane Doe', '25', '10',
                     "She has an amazing backhand that I can't beat",
                     'She cannot spin spin the ball very well',
                     'She likes playing up-close to the table'
        )
        click_on 'Submit'

        visit players_path
        expect(page).to(have_content('Jane Doe'))
      end

      it 'new player allows strengths, weaknesses, and additional info to have special characters' do
        click_on 'New Player'
        str = "`~1!2@3#4$5%6^7&8*9(0)-_=+qQwWeErRtTyYuUiIoOpP[{]}\|aAsSdDfFgGhHjJkKlL;:'\"zZxXcCvVbBnNmM,<.>/? \n\t "
        fill_in_form('Bossman', '15', '10', str, str, str)
        click_on 'Submit'

        visit players_path
        expect(page).to(have_content('Bossman'))
      end
    end

    context('when creating a player is unsuccessful') do
      it 'new player has invalid attributes' do
        click_on 'New Player'
        fill_in_form('Bossman', '-5', '-1', '', '', '')
        click_on 'Submit'

        visit players_path
        expect(page).not_to(have_content('Bossman'))
      end

      it 'new player has blank name' do
        click_on 'New Player'
        fill_in_form('', '5', '10', '', '', '')
        click_on 'Submit'

        # verify expected error messages
        expect(page).to(have_content("Name can't be blank"))

        visit players_path
        expect(page).not_to(have_content('5'))
        expect(page).not_to(have_content('10'))
      end

      it 'new player has special character(s) in name' do
        click_on 'New Player'
        fill_in_form('Texas A&M', '10', '10', '', '', '')
        click_on 'Submit'

        # verify expected error messages
        expect(page).to(have_content("Cannot use any special characters other than spaces, '-' (dashes), or '_' (underscores)"))

        visit players_path
        expect(page).not_to(have_content('5'))
        expect(page).not_to(have_content('10'))
      end

      it 'new player has blank losses' do
        click_on 'New Player'
        fill_in_form('Bossman', '', '10', '', '', '')
        click_on 'Submit'

        # verify expected error messages
        expect(page).to(have_content("Losses can't be blank"))
        expect(page).to(have_content('Losses values must be between 0 and 2,147,483,647'))

        visit players_path
        expect(page).not_to(have_content('Bossman'))
      end

      it 'new player has blank wins' do
        click_on 'New Player'
        fill_in_form('Bossman', '25', '', '', '', '')
        click_on 'Submit'

        # verify expected error messages
        expect(page).to(have_content("Wins can't be blank"))
        expect(page).to(have_content('Wins values must be between 0 and 2,147,483,647'))

        visit players_path
        expect(page).not_to(have_content('Bossman'))
      end

      it 'new player has non-numeric losses' do
        click_on 'New Player'
        fill_in_form('Bossman', 'asdfasd', '10', '', '', '')
        click_on 'Submit'

        # verify expected error messages
        expect(page).to(have_content('Losses values must be between 0 and 2,147,483,647'))

        visit players_path
        expect(page).not_to(have_content('Bossman'))
      end

      it 'new player has non-numeric wins' do
        click_on 'New Player'
        fill_in_form('Bossman', '25', 'asdfasd', '', '', '')
        click_on 'Submit'

        # verify expected error messages
        expect(page).to(have_content('Wins values must be between 0 and 2,147,483,647'))

        visit players_path
        expect(page).not_to(have_content('Bossman'))
      end

      it 'new player has negative losses' do
        click_on 'New Player'
        fill_in_form('Bossman', '-5', '3', '', '', '')
        click_on 'Submit'

        # verify expected error messages
        expect(page).to(have_content('Losses values must be between 0 and 2,147,483,647'))

        visit players_path
        expect(page).not_to(have_content('Bossman'))
      end

      it 'new player has losses just out of bounds from above' do
        click_on 'New Player'
        fill_in_form('Bossman', '2147483648', '3', '', '', '')
        click_on 'Submit'

        # verify expected error messages
        expect(page).to(have_content('Losses values must be between 0 and 2,147,483,647'))

        visit players_path
        expect(page).not_to(have_content('Bossman'))
      end

      it 'new player has negative wins' do
        click_on 'New Player'
        fill_in_form('Bossman', '3', '-5', '', '', '')
        click_on 'Submit'

        # verify expected error messages
        expect(page).to(have_content('Wins values must be between 0 and 2,147,483,647'))

        visit players_path
        expect(page).not_to(have_content('Bossman'))
      end

      it 'new player has wins just out of bounds from above' do
        click_on 'New Player'
        fill_in_form('Bossman', '3', '2147483648', '', '', '')
        click_on 'Submit'

        # verify expected error messages
        expect(page).to(have_content('Wins values must be between 0 and 2,147,483,647'))

        visit players_path
        expect(page).not_to(have_content('Bossman'))
      end

      it 'new player has negative losses & wins' do
        click_on 'New Player'
        fill_in_form('Bossman', '-3', '-5', '', '', '')
        click_on 'Submit'

        # verify expected error messages
        expect(page).to(have_content('Losses values must be between 0 and 2,147,483,647'))
        expect(page).to(have_content('Wins values must be between 0 and 2,147,483,647'))

        visit players_path
        expect(page).not_to(have_content('Bossman'))
      end
    end
  end

  describe('#edit feature') do
    it 'is able to edit a player' do
      created_player = create_valid_player

      visit players_path

      edit_player(created_player.id)

      # expect(page).to(have_selector(:link_or_button, 'Submit'))
      expect(page).to(have_content("Editing #{created_player.name}"))
    end

    context('when editing a player is successful') do
      it 'updated player has valid attributes' do
        created_player = create_valid_player

        visit players_path
        edit_player(created_player.id)
        fill_in_form('Bossman', '9', '8', '', '', '')
        click_on 'Submit'

        visit players_path
        expect(page).to(have_content('Bossman'))
        expect(page).to(have_content('9'))
        expect(page).to(have_content('8'))

        expect(page).not_to(have_content('Jane Doe'))
        expect(page).not_to(have_content('25'))
        expect(page).not_to(have_content('10'))
      end
    end

    context('when editing a player is unsuccessful') do
      it 'updated player has invalid attributes' do
        created_player = create_valid_player

        visit players_path
        edit_player(created_player.id)
        fill_in_form('Bossgirl', '1', '-3', '', '', '')
        click_on 'Submit'

        visit players_path
        expect(page).not_to(have_content('Bossgirl'))
        expect(page).to(have_content('Jane Doe'))
        expect(page).to(have_content('25'))
        expect(page).to(have_content('10'))
      end
    end
  end

  describe('#delete feature') do
    it 'is able to delete a player' do
      created_player = create_valid_player

      visit players_path
      delete_player(created_player.id)

      # alert = page.driver.browser.switch_to.alert.accept
      # expect(page.driver.browser.switch_to.alert).to include('Are you sure?')
      begin
        page.driver.browser.switch_to.alert.accept
      rescue StandardError
        Selenium::WebDriver::Error::NoSuchAlertError
      end

      expect(page).not_to(have_content(created_player.name))
    end
  end
end
