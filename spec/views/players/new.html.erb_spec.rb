require 'rails_helper'

RSpec.describe "players/new", type: :view do
  before(:each) do
    assign(:player, Player.new(
      name: "MyString",
      played: 1,
      wins: 1,
      strengths: "MyText",
      weaknesses: "MyText",
      additional_info: "MyText"
    ))
  end

  it "renders new player form" do
    render

    assert_select "form[action=?][method=?]", players_path, "post" do

      assert_select "input[name=?]", "player[name]"

      assert_select "input[name=?]", "player[played]"

      assert_select "input[name=?]", "player[wins]"

      assert_select "textarea[name=?]", "player[strengths]"

      assert_select "textarea[name=?]", "player[weaknesses]"

      assert_select "textarea[name=?]", "player[additional_info]"
    end
  end
end
