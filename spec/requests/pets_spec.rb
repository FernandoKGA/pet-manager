require 'rails_helper'

RSpec.describe "Pets", type: :request do
  let!(:user) { FactoryBot.create(:user) }
  let!(:pet) { FactoryBot.create(:pet, user: user) }

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

  describe "POST /pets" do
    context "with valid params" do
      let(:valid_attributes) do
        { 
          pet: FactoryBot.attributes_for(:pet, name: "Novo Pet", species: "Cachorro") 
        }
      end

      it "creates a new Pet and redirects" do
        expect do
          post pets_path, params: valid_attributes
        end.to change(Pet, :count).by(1)

        expect(response).to redirect_to(user_path(user))
        follow_redirect!
        expect(response.body).to include("Pet cadastrado com sucesso!")
      end
    end

    context "with invalid params" do
      let(:invalid_attributes) { { pet: { name: "" } } }

      it "does not create a new Pet and renders new" do
        expect do
          post pets_path, params: invalid_attributes
        end.to_not change(Pet, :count)

        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

  describe "PATCH /pets/:id" do
    context "with valid params" do
      let(:new_attributes) { { pet: { name: "Rex Atualizado" } } }

      it "updates the requested pet" do
        patch pet_path(pet), params: new_attributes
        pet.reload
        expect(pet.name).to eq("Rex Atualizado")
        expect(response).to redirect_to(user_path(user))
      end
    end

    context "with invalid params" do
      let(:invalid_attributes) { { pet: { name: "" } } }

      it "does not update the pet and renders edit" do
        patch pet_path(pet), params: invalid_attributes
        pet.reload
        expect(pet.name).not_to eq("")
        expect(response).to have_http_status(:unprocessable_content)
      end
    end

    context "removing photo" do
      it "calls remove_photo! when checkbox is checked" do
        expect_any_instance_of(Pet).to receive(:remove_photo!)
        
        patch pet_path(pet), params: { pet: { remove_photo: '1' } }
      end
    end
  end

  describe "DELETE /pets/:id" do
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

    context "when destroying the pet fails" do
      before do
        allow_any_instance_of(Pet).to receive(:destroy).and_return(false)
      end

      it "redirects to user path with an alert message" do
        delete pet_path(pet)

        expect(Pet.where(id: pet.id)).to exist
        expect(response).to redirect_to(user_path(user))
        
        follow_redirect!
        expect(response.body).to include("Não foi possível excluir o Pet.")
      end
    end
  end
end