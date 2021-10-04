# location: spec/feature/players_integration_spec.rb
require 'rails_helper'
require "selenium-webdriver"

RSpec.describe 'Players Features', type: :feature do
    before do
        Rails.application.env_config["devise.mapping"] = Devise.mappings[:admin] # If using Devise
        Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:google]
        visit root_path
        # sign in and verify sign in
        click_on 'Get Started!'
    end

    before(:each) do
        visit root_path
        # start with fresh player database on every run
        Player.delete_all
    end

    scenario 'At root page after login' do
        expect(page).to have_current_path(root_path)
        expect(page).to have_content ('Players')
        expect(page).to have_selector(:link_or_button, 'Add a New Player')
    end

    scenario 'Able to go to players#index page and have contents be the same as root page' do
        visit players_path
        expect(page).to have_current_path(players_path)
        expect(page).to have_content ('Players')
        expect(page).to have_selector(:link_or_button, 'Add a New Player')
    end

    scenario 'Able to go to page to create a new player' do
        expect(page).to have_selector(:link_or_button, 'Add a New Player')
        click_on 'Add a New Player'
        expect(page).to have_current_path(new_player_path)
    end

    scenario 'Able to create a new player with valid attributes' do
        click_on 'Add a New Player'
        fill_in_form("Jane Doe", "25", "10", 
                        "She has an amazing backhand that I can't beat", 
                        "She cannot spin spin the ball very well", 
                        "She likes playing up-close to the table")
        click_on 'Submit'
        
        visit players_path
        expect(page).to have_content("Jane Doe")
    end
    #here
    scenario 'Unable to create a new player with invalid attributes' do
        click_on 'Add a New Player'
        fill_in_form("Bossman", "5", "10", "", "", "")
        click_on 'Submit'
        
        visit players_path
        expect(page).to_not have_content("Bossman")
    end

    scenario 'Unable to create a new player with invalid attributes -> Blank name' do
        click_on 'Add a New Player'
        fill_in_form("", "5", "10", "", "", "")
        click_on 'Submit'
        
        # verify expected error messages
        expect(page).to have_content("Name can't be blank")
        
        visit players_path
        expect(page).to_not have_content("5")
        expect(page).to_not have_content("10")
    end

    scenario 'Unable to create a new player with invalid attributes -> Name has special character(s)' do
        click_on 'Add a New Player'
        fill_in_form("Texas A&M", "10", "10", "", "", "")
        fill_in 'player[name]', with: "Texas A&M"
        fill_in 'player[played]', with: "10"
        fill_in 'player[wins]', with: "10"
        fill_in 'player[strengths]', with: ""
        fill_in 'player[weaknesses]', with: ""
        fill_in 'player[additional_info]', with: ""
        click_on 'Submit'
        
        # verify expected error messages
        expect(page).to have_content("Cannot use any special characters other than spaces, '-' (dashes), or '_' (underscores)")
        
        visit players_path
        expect(page).to_not have_content("5")
        expect(page).to_not have_content("10")
    end

    scenario 'Unable to create a new player with invalid attributes -> Blank played' do
        click_on 'Add a New Player'
        fill_in_form("Bossman", "", "10", "", "", "")
        click_on 'Submit'
        
        # verify expected error messages
        expect(page).to have_content("Played can't be blank")
        expect(page).to have_content("Played values must be between 0 and 2,147,483,647")
        expect(page).to have_content("Played cannot be less than wins")
        
        visit players_path
        expect(page).to_not have_content("Bossman")
    end

    scenario 'Unable to create a new player with invalid attributes -> Blank wins' do
        click_on 'Add a New Player'
        fill_in_form("Bossman", "25", "", "", "", "")
        click_on 'Submit'
        
        # verify expected error messages
        expect(page).to have_content("Wins can't be blank")
        expect(page).to have_content("Wins values must be between 0 and 2,147,483,647")
        
        visit players_path
        expect(page).to_not have_content("Bossman")
    end

    scenario 'Unable to create a new player with invalid attributes -> Non-numeric played' do
        click_on 'Add a New Player'
        fill_in_form("Bossman", "asdfasd", "10", "", "", "")
        click_on 'Submit'
        
        # verify expected error messages
        expect(page).to have_content("Played values must be between 0 and 2,147,483,647")
        expect(page).to have_content("Played cannot be less than wins")
        
        visit players_path
        expect(page).to_not have_content("Bossman")
    end

    scenario 'Unable to create a new player with invalid attributes -> Non-numeric wins' do
        click_on 'Add a New Player'
        fill_in_form("Bossman", "25", "asdfasd", "", "", "")
        click_on 'Submit'
        
        # verify expected error messages
        expect(page).to have_content("Wins values must be between 0 and 2,147,483,647")
        
        visit players_path
        expect(page).to_not have_content("Bossman")
    end

    scenario 'Unable to create a new player with invalid attributes -> Negative played' do
        click_on 'Add a New Player'
        fill_in_form("Bossman", "-5", "3", "", "", "")
        click_on 'Submit'
        
        # verify expected error messages
        expect(page).to have_content("Played values must be between 0 and 2,147,483,647")
        expect(page).to have_content("Played cannot be less than wins")
        
        visit players_path
        expect(page).to_not have_content("Bossman")
    end

    scenario 'Unable to create a new player with invalid attributes -> Played just out of bounds from above' do
        click_on 'Add a New Player'
        fill_in_form("Bossman", "2147483648", "3", "", "", "")
        click_on 'Submit'
        
        # verify expected error messages
        expect(page).to have_content("Played values must be between 0 and 2,147,483,647")
        
        visit players_path
        expect(page).to_not have_content("Bossman")
    end

    scenario 'Unable to create a new player with invalid attributes -> Negative wins' do
        click_on 'Add a New Player'
        fill_in_form("Bossman", "3", "-5", "", "", "")
        click_on 'Submit'
        
        # verify expected error messages
        expect(page).to have_content("Wins values must be between 0 and 2,147,483,647")
        
        visit players_path
        expect(page).to_not have_content("Bossman")
    end

    scenario 'Unable to create a new player with invalid attributes -> Played just out of bounds from above' do
        click_on 'Add a New Player'
        fill_in_form("Bossman", "3", "2147483648", "", "", "")
        click_on 'Submit'
        
        # verify expected error messages
        expect(page).to have_content("Wins values must be between 0 and 2,147,483,647")
        expect(page).to have_content("Played cannot be less than wins")
        
        visit players_path
        expect(page).to_not have_content("Bossman")
    end

    scenario 'Unable to create a new player with invalid attributes -> Negative played & wins' do
        click_on 'Add a New Player'
        fill_in_form("Bossman", "-3", "-5", "", "", "")
        click_on 'Submit'
        
        # verify expected error messages
        expect(page).to have_content("Played values must be between 0 and 2,147,483,647")
        expect(page).to have_content("Wins values must be between 0 and 2,147,483,647")
        
        visit players_path
        expect(page).to_not have_content("Bossman")
    end

    scenario 'Unable to create a new player with invalid attributes -> wins > played' do
        click_on 'Add a New Player'
        fill_in_form("Bossman", "5", "6", "", "", "")
        click_on 'Submit'
        
        # verify expected error messages
        expect(page).to have_content("Played cannot be less than wins")
        
        visit players_path
        expect(page).to_not have_content("Bossman")
    end

    scenario 'Unable to create a new player with valid attributes -> strengths, weaknesses, and additional info have special characters' do
        click_on 'Add a New Player'
        fill_in_form("Bossman", "15", "10", 
                        "`~1!2@3#4$5%6^7&8*9(0)-_=+qQwWeErRtTyYuUiIoOpP[{]}\|aAsSdDfFgGhHjJkKlL;:'\"zZxXcCvVbBnNmM,<.>/? \n\t ", 
                        "`~1!2@3#4$5%6^7&8*9(0)-_=+qQwWeErRtTyYuUiIoOpP[{]}\|aAsSdDfFgGhHjJkKlL;:'\"zZxXcCvVbBnNmM,<.>/? \n\t ", 
                        "`~1!2@3#4$5%6^7&8*9(0)-_=+qQwWeErRtTyYuUiIoOpP[{]}\|aAsSdDfFgGhHjJkKlL;:'\"zZxXcCvVbBnNmM,<.>/? \n\t ")
        click_on 'Submit'
        
        visit players_path
        expect(page).to have_content("Bossman")
    end

    scenario 'Able to edit a player' do
        created_player = create_valid_player
        
        visit players_path

        edit_player(created_player.id)

        expect(page).to have_selector(:link_or_button, 'Submit')
        expect(page).to have_content("Editing #{created_player.name}")
    end

    scenario 'Unable to udpate a player with invalid attributes' do
        created_player = create_valid_player
        
        visit players_path
        edit_player(created_player.id)
        fill_in_form("Bossman", "5", "10", "", "", "")
        click_on 'Submit'
        
        visit players_path
        expect(page).to_not have_content("Bossman")
        expect(page).to have_content("Jane Doe")
        expect(page).to have_content("25")
        expect(page).to have_content("10")
    end

    scenario 'Able to delete a player' do
        created_player = create_valid_player

        visit players_path
        delete_player(created_player.id)

        # alert = page.driver.browser.switch_to.alert.accept
        # expect(page.driver.browser.switch_to.alert).to include('Are you sure?') 
        page.driver.browser.switch_to.alert.accept rescue Selenium::WebDriver::Error::NoSuchAlertError

        expect(page).to_not have_content(created_player.name)
    end

    private
        def create_valid_player
            click_on 'Add a New Player'
            fill_in 'player[name]', with: "Jane Doe"
            fill_in 'player[played]', with: "25"
            fill_in 'player[wins]', with: "10"
            fill_in 'player[strengths]', with: "She has an amazing backhand that I can't beat"
            fill_in 'player[weaknesses]', with: "She cannot spin spin the ball very well"
            fill_in 'player[additional_info]', with: "She likes playing up-close to the table"
            click_on 'Submit'

            Player.where(name: "Jane Doe", played: "25", wins: "10", 
                            strengths: "She has an amazing backhand that I can't beat", 
                            weaknesses: "She cannot spin spin the ball very well", 
                            additional_info: "She likes playing up-close to the table"
            ).first
        end

        def edit_player(player_id)
            within('table') do    
                find("a[href=\"/players/#{player_id}/edit\"]").click
            end
            
        end

        def delete_player(player_id)
            within('.actions') do    
                find("a[href=\"/players/#{player_id}\"]").click
            end
        end

        def fill_in_form(name, played, wins, strengths, weaknesses, additional_info)
            fill_in 'player[name]', with: name
            fill_in 'player[played]', with: played
            fill_in 'player[wins]', with: wins
            fill_in 'player[strengths]', with: strengths
            fill_in 'player[weaknesses]', with: weaknesses
            fill_in 'player[additional_info]', with: weaknesses
        end


end