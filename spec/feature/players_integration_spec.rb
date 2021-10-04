# location: spec/feature/players_integration_spec.rb
require 'rails_helper'

RSpec.describe 'Players Features', type: :feature do
    before do
        Rails.application.env_config["devise.mapping"] = Devise.mappings[:admin] # If using Devise
        Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:google]
        visit root_path
        # sign in and verify sign in
        click_on 'Sign in with Google'
    end

    before(:each) do
        visit root_path
        Player.delete_all
    end

    scenario 'At root page after login' do
        expect(page).to have_current_path(root_path)
        expect(page).to have_content ('Players')
        expect(page).to have_content ('New Player')
    end

    scenario 'Able to go to players#index page and have contents be the same as root page' do
        visit players_path
        expect(page).to have_current_path(players_path)
        expect(page).to have_content ('Players')
        expect(page).to have_content ('New Player')
    end

    scenario 'Able to go to page to create a new player' do
        expect(find_link('New Player')[:href]).to eq(new_player_path)
        click_on 'New Player'
        expect(page).to have_current_path(new_player_path)
    end

    scenario 'Able to create a new player with valid attributes' do
        click_on 'New Player'
        fill_in 'player[name]', with: "Jane Doe"
        fill_in 'player[played]', with: "25"
        fill_in 'player[wins]', with: "10"
        fill_in 'player[strengths]', with: "She has an amazing backhand that I can't beat"
        fill_in 'player[weaknesses]', with: "She cannot spin spin the ball very well"
        fill_in 'player[additional_info]', with: "She likes playing up-close to the table"
        click_on 'Create Player'
        
        visit players_path
        expect(page).to have_content("Jane Doe")
    end

    scenario 'Unable to create a new player with invalid attributes' do
        click_on 'New Player'
        fill_in 'player[name]', with: "Bossman"
        fill_in 'player[played]', with: "5"
        fill_in 'player[wins]', with: "10"
        fill_in 'player[strengths]', with: ""
        fill_in 'player[weaknesses]', with: ""
        fill_in 'player[additional_info]', with: ""
        click_on 'Create Player'
        
        visit players_path
        expect(page).to_not have_content("Bossman")
    end

    scenario 'Unable to create a new player with invalid attributes -> Blank name' do
        click_on 'New Player'
        fill_in 'player[name]', with: ""
        fill_in 'player[played]', with: "5"
        fill_in 'player[wins]', with: "10"
        fill_in 'player[strengths]', with: ""
        fill_in 'player[weaknesses]', with: ""
        fill_in 'player[additional_info]', with: ""
        click_on 'Create Player'
        
        # verify expected error messages
        expect(page).to have_content("Name can't be blank")
        
        visit players_path
        expect(page).to_not have_content("5")
        expect(page).to_not have_content("10")
    end

    scenario 'Unable to create a new player with invalid attributes -> Name has special character(s)' do
        click_on 'New Player'
        fill_in 'player[name]', with: "Texas A&M"
        fill_in 'player[played]', with: "10"
        fill_in 'player[wins]', with: "10"
        fill_in 'player[strengths]', with: ""
        fill_in 'player[weaknesses]', with: ""
        fill_in 'player[additional_info]', with: ""
        click_on 'Create Player'
        
        # verify expected error messages
        expect(page).to have_content("Cannot use any special characters other than spaces, '-' (dashes), or '_' (underscores)")
        
        visit players_path
        expect(page).to_not have_content("5")
        expect(page).to_not have_content("10")
    end

    scenario 'Unable to create a new player with invalid attributes -> Blank played' do
        click_on 'New Player'
        fill_in 'player[name]', with: "Bossman"
        fill_in 'player[played]', with: ""
        fill_in 'player[wins]', with: "10"
        fill_in 'player[strengths]', with: ""
        fill_in 'player[weaknesses]', with: ""
        fill_in 'player[additional_info]', with: ""
        click_on 'Create Player'
        
        # verify expected error messages
        expect(page).to have_content("Played can't be blank")
        expect(page).to have_content("Played values must be between 0 and 2,147,483,647")
        expect(page).to have_content("Played cannot be less than wins")
        
        visit players_path
        expect(page).to_not have_content("Bossman")
    end

    scenario 'Unable to create a new player with invalid attributes -> Blank wins' do
        click_on 'New Player'
        fill_in 'player[name]', with: "Bossman"
        fill_in 'player[played]', with: "25"
        fill_in 'player[wins]', with: ""
        fill_in 'player[strengths]', with: ""
        fill_in 'player[weaknesses]', with: ""
        fill_in 'player[additional_info]', with: ""
        click_on 'Create Player'
        
        # verify expected error messages
        expect(page).to have_content("Wins can't be blank")
        expect(page).to have_content("Wins values must be between 0 and 2,147,483,647")
        
        visit players_path
        expect(page).to_not have_content("Bossman")
    end

    scenario 'Unable to create a new player with invalid attributes -> Non-numeric played' do
        click_on 'New Player'
        fill_in 'player[name]', with: "Bossman"
        fill_in 'player[played]', with: "asdfasd"
        fill_in 'player[wins]', with: "10"
        fill_in 'player[strengths]', with: ""
        fill_in 'player[weaknesses]', with: ""
        fill_in 'player[additional_info]', with: ""
        click_on 'Create Player'
        
        # verify expected error messages
        expect(page).to have_content("Played values must be between 0 and 2,147,483,647")
        expect(page).to have_content("Played cannot be less than wins")
        
        visit players_path
        expect(page).to_not have_content("Bossman")
    end

    scenario 'Unable to create a new player with invalid attributes -> Non-numeric wins' do
        click_on 'New Player'
        fill_in 'player[name]', with: "Bossman"
        fill_in 'player[played]', with: "25"
        fill_in 'player[wins]', with: "asdfasd"
        fill_in 'player[strengths]', with: ""
        fill_in 'player[weaknesses]', with: ""
        fill_in 'player[additional_info]', with: ""
        click_on 'Create Player'
        
        # verify expected error messages
        expect(page).to have_content("Wins values must be between 0 and 2,147,483,647")
        
        visit players_path
        expect(page).to_not have_content("Bossman")
    end

    scenario 'Unable to create a new player with invalid attributes -> Negative played' do
        click_on 'New Player'
        fill_in 'player[name]', with: "Bossman"
        fill_in 'player[played]', with: "-5"
        fill_in 'player[wins]', with: "3"
        fill_in 'player[strengths]', with: ""
        fill_in 'player[weaknesses]', with: ""
        fill_in 'player[additional_info]', with: ""
        click_on 'Create Player'
        
        # verify expected error messages
        expect(page).to have_content("Played values must be between 0 and 2,147,483,647")
        expect(page).to have_content("Played cannot be less than wins")
        
        visit players_path
        expect(page).to_not have_content("Bossman")
    end

    scenario 'Unable to create a new player with invalid attributes -> Played just out of bounds from above' do
        click_on 'New Player'
        fill_in 'player[name]', with: "Bossman"
        fill_in 'player[played]', with: "2147483648"
        fill_in 'player[wins]', with: "3"
        fill_in 'player[strengths]', with: ""
        fill_in 'player[weaknesses]', with: ""
        fill_in 'player[additional_info]', with: ""
        click_on 'Create Player'
        
        # verify expected error messages
        expect(page).to have_content("Played values must be between 0 and 2,147,483,647")
        
        visit players_path
        expect(page).to_not have_content("Bossman")
    end

    scenario 'Unable to create a new player with invalid attributes -> Negative wins' do
        click_on 'New Player'
        fill_in 'player[name]', with: "Bossman"
        fill_in 'player[played]', with: "3"
        fill_in 'player[wins]', with: "-5"
        fill_in 'player[strengths]', with: ""
        fill_in 'player[weaknesses]', with: ""
        fill_in 'player[additional_info]', with: ""
        click_on 'Create Player'
        
        # verify expected error messages
        expect(page).to have_content("Wins values must be between 0 and 2,147,483,647")
        
        visit players_path
        expect(page).to_not have_content("Bossman")
    end

    scenario 'Unable to create a new player with invalid attributes -> Played just out of bounds from above' do
        click_on 'New Player'
        fill_in 'player[name]', with: "Bossman"
        fill_in 'player[played]', with: "3"
        fill_in 'player[wins]', with: "2147483648"
        fill_in 'player[strengths]', with: ""
        fill_in 'player[weaknesses]', with: ""
        fill_in 'player[additional_info]', with: ""
        click_on 'Create Player'
        
        # verify expected error messages
        expect(page).to have_content("Wins values must be between 0 and 2,147,483,647")
        expect(page).to have_content("Played cannot be less than wins")
        
        visit players_path
        expect(page).to_not have_content("Bossman")
    end

    scenario 'Unable to create a new player with invalid attributes -> Negative played & wins' do
        click_on 'New Player'
        fill_in 'player[name]', with: "Bossman"
        fill_in 'player[played]', with: "-3"
        fill_in 'player[wins]', with: "-5"
        fill_in 'player[strengths]', with: ""
        fill_in 'player[weaknesses]', with: ""
        fill_in 'player[additional_info]', with: ""
        click_on 'Create Player'
        
        # verify expected error messages
        expect(page).to have_content("Played values must be between 0 and 2,147,483,647")
        expect(page).to have_content("Wins values must be between 0 and 2,147,483,647")
        
        visit players_path
        expect(page).to_not have_content("Bossman")
    end

    scenario 'Unable to create a new player with invalid attributes -> wins > played' do
        click_on 'New Player'
        fill_in 'player[name]', with: "Bossman"
        fill_in 'player[played]', with: "5"
        fill_in 'player[wins]', with: "6"
        fill_in 'player[strengths]', with: ""
        fill_in 'player[weaknesses]', with: ""
        fill_in 'player[additional_info]', with: ""
        click_on 'Create Player'
        
        # verify expected error messages
        expect(page).to have_content("Played cannot be less than wins")
        
        visit players_path
        expect(page).to_not have_content("Bossman")
    end

    scenario 'Unable to create a new player with valid attributes -> strengths, weaknesses, and additional info have special characters' do
        click_on 'New Player'
        fill_in 'player[name]', with: "Bossman"
        fill_in 'player[played]', with: "15"
        fill_in 'player[wins]', with: "10"
        fill_in 'player[strengths]', with: "`~1!2@3#4$5%6^7&8*9(0)-_=+qQwWeErRtTyYuUiIoOpP[{]}\|aAsSdDfFgGhHjJkKlL;:'\"zZxXcCvVbBnNmM,<.>/? \n\t "
        fill_in 'player[weaknesses]', with: "`~1!2@3#4$5%6^7&8*9(0)-_=+qQwWeErRtTyYuUiIoOpP[{]}\|aAsSdDfFgGhHjJkKlL;:'\"zZxXcCvVbBnNmM,<.>/? \n\t "
        fill_in 'player[additional_info]', with: "`~1!2@3#4$5%6^7&8*9(0)-_=+qQwWeErRtTyYuUiIoOpP[{]}\|aAsSdDfFgGhHjJkKlL;:'\"zZxXcCvVbBnNmM,<.>/? \n\t "
        click_on 'Create Player'
        
        visit players_path
        expect(page).to have_content("Bossman")
    end
end