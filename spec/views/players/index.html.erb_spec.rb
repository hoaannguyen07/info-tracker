require 'rails_helper'

RSpec.describe "players/index", type: :view do
  before(:each) do
    assign(:players, [
      Player.create!(
        name: "Name",
        played: 2,
        wins: 3,
        strengths: "MyText",
        weaknesses: "MyText",
        additional_info: "MyText"
      ),
      Player.create!(
        name: "Name",
        played: 2,
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
    assert_select "tr>td", text: 2.to_s, count: 2
    assert_select "tr>td", text: 3.to_s, count: 2
    assert_select "tr>td", text: "MyText".to_s, count: 2
    assert_select "tr>td", text: "MyText".to_s, count: 2
    assert_select "tr>td", text: "MyText".to_s, count: 2
  end
end
