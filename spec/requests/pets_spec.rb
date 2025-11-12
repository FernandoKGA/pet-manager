require 'rails_helper'

RSpec.describe "Pets", type: :request do
  let!(:user) { FactoryBot.create(:user) }

  before do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    allow_any_instance_of(ActionView::Base).to receive(:current_user).and_return(user)
  end

  describe "GET /pets/new" do
    it "returns http success" do
      get new_pet_path
      expect(response).to have_http_status(:ok)
    end
  end
end
