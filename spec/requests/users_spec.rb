require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "GET /main" do
    it "returns http success" do
      get "/users/main"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /notes" do
    it "returns http success" do
      get "/users/notes"
      expect(response).to have_http_status(:success)
    end
  end

end
