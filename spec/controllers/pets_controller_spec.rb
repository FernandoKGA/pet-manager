require 'rails_helper'

RSpec.describe PetsController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  let(:pet) { FactoryBot.create(:pet, user: user) }

  before do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    allow_any_instance_of(SessionsHelper).to receive(:current_user).and_return(user)
  end

  describe "POST #create" do
    context "with valid params" do
      it "saves the new pet" do
        expect {
          post :create, params: { pet: FactoryBot.attributes_for(:pet) }
        }.to change(Pet, :count).by(1)
      end

      it "redirects to user path" do
        post :create, params: { pet: FactoryBot.attributes_for(:pet) }
        expect(response).to redirect_to(user_path(user))
        expect(flash[:notice]).to eq("Pet cadastrado com sucesso!")
      end

      it "attaches uploaded file if present" do
        file = fixture_file_upload('spec/fixtures/files/bee.png', 'image/png')
        
        expect_any_instance_of(Pet).to receive(:attach_uploaded_file)
        post :create, params: { pet: FactoryBot.attributes_for(:pet).merge(photo_file: file) }
      end
    end

    context "with invalid params" do
      it "re-renders the new template" do
        post :create, params: { pet: { name: nil } }
        expect(response).to render_template(:new)
        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      it "updates the requested pet" do
        put :update, params: { id: pet.id, pet: { name: "Novo Nome" } }
        pet.reload
        expect(pet.name).to eq("Novo Nome")
      end

      it "redirects to the user path" do
        put :update, params: { id: pet.id, pet: { name: "Novo Nome" } }
        expect(response).to redirect_to(user_path(user))
      end
    end

    context "photo handling" do
      it "removes photo when remove_photo is '1'" do
        expect_any_instance_of(Pet).to receive(:remove_photo!)
        put :update, params: { id: pet.id, pet: { remove_photo: '1' } }
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:pet_to_delete) { FactoryBot.create(:pet, user: user) }

    it "destroys the requested pet" do
      expect {
        delete :destroy, params: { id: pet_to_delete.id }
      }.to change(Pet, :count).by(-1)
    end

    it "redirects to the user list" do
      delete :destroy, params: { id: pet_to_delete.id }
      expect(response).to redirect_to(user_path(user))
    end
  end

  describe "Strong Parameters" do
    it "permits allowed attributes" do
      params = { 
        pet: { 
          name: "Rex", 
          birthdate: "2020-01-01", 
          size: "Medium",
          species: "Dog",
          breed: "Labrador",
          gender: "Male",
          sinpatinhas_id: "123",
          remove_photo: "1",
          photo_file: "file_data"
        } 
      }
      
      put :update, params: params.merge(id: pet.id)
      
      permitted_params = controller.send(:pet_params)
      
      expect(permitted_params).to include(:name, :birthdate, :size, :species, :breed, :gender, :sinpatinhas_id, :photo_file, :remove_photo)
    end

    it "filters out unpermitted attributes" do
      params = { 
        pet: { 
          name: "Rex", 
          admin: true,
          user_id: 999
        } 
      }

      put :update, params: params.merge(id: pet.id)
      
      permitted_params = controller.send(:pet_params)
      
      expect(permitted_params).not_to include(:admin)
      expect(permitted_params).not_to include(:user_id)
      expect(permitted_params).to include(:name)
    end
  end
end