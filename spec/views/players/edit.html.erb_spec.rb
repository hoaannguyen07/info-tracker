require 'rails_helper'

RSpec.describe "players/edit", type: :view do
  before(:each) do
    @player = assign(:player, Player.create!(
      name: "MyString",
      played: 1,
      wins: 1,
      strengths: "MyText",
      weaknesses: "MyText",
      additional_info: "MyText"
    ))
  end

  it "renders the edit player form" do
    render

    assert_select "form[action=?][method=?]", player_path(@player), "post" do

      assert_select "input[name=?]", "player[name]"

      assert_select "input[name=?]", "player[played]"

      assert_select "input[name=?]", "player[wins]"

      assert_select "textarea[name=?]", "player[strengths]"

      assert_select "textarea[name=?]", "player[weaknesses]"

      assert_select "textarea[name=?]", "player[additional_info]"
    end
  end
end
