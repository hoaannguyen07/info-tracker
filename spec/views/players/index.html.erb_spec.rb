require 'rails_helper'

RSpec.describe "players/index", type: :view do
  before do
    # Rails.application.env_config["devise.mapping"] = Devise.mappings[:admin] # If using Devise
    # Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:google]

    if (Admin.where(email: "views_players@gmail.com").first.nil? == true)
      Admin.create(email: "views_players@gmail.com", full_name: "View Players Test", uid: "123abc456", avatar_url: "www.example.com")
    end
  end
  before(:each) do
    assign(:players, [
      Player.create!(
        admin_id: Admin.where(email: "views_players@gmail.com").first.id,
        name: "Name",
        played: 5,
        wins: 3,
        strengths: "MyText",
        weaknesses: "MyText",
        additional_info: "MyText"
      ),
      Player.create!(
        admin_id: Admin.where(email: "views_players@gmail.com").first.id,
        name: "Name",
        played: 5,
        wins: 3,
        strengths: "MyText",
        weaknesses: "MyText",
        additional_info: "MyText"
      )
    ])
  end

  it "renders a list of players" do
    render
    assert_select "tr>td", text: "Name".to_s, count: 2
    assert_select "tr>td", text: 5.to_s, count: 2
    assert_select "tr>td", text: 3.to_s, count: 2
    assert_select "tr>td", text: "MyText".to_s, count: 2
    assert_select "tr>td", text: "MyText".to_s, count: 2
    assert_select "tr>td", text: "MyText".to_s, count: 2
  end
end
