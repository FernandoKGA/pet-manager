require 'rails_helper'

RSpec.describe "Pets", type: :request do
  let!(:user) { FactoryBot.create(:user) }

  before do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    allow_any_instance_of(SessionsHelper).to receive(:current_user).and_return(user)
  end

  describe "GET /pets/new" do
    it "returns http success" do
      get new_pet_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "DELETE /pets/:id" do
    let!(:pet) { create(:pet, user: user) }

    before do
      create(:medication, pet: pet)
      create(:weight, pet: pet)
    end

    it "excludes the pet and all related data" do
      expect do
        delete pet_path(pet)
      end.to change(Pet, :count).by(-1)

      expect(Medication.where(pet_id: pet.id)).to be_empty
      expect(Weight.where(pet_id: pet.id)).to be_empty
      expect(response).to redirect_to(user_path(user))

      follow_redirect!
      expect(response.body).to include("Pet excluído com sucesso!")
    end
  end
end
