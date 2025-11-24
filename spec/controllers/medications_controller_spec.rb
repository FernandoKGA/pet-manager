require 'rails_helper'

RSpec.describe MedicationsController, type: :controller do
  let!(:user) { create(:user) }
  let!(:pet) { create(:pet, user: user) }
  let!(:medication) { create(:medication, pet: pet) }

  let(:valid_attributes) {
    attributes_for(:medication, name: "Anti-pulgas", dosage: "1 pipeta")
  }
  
  let(:invalid_attributes) {
    attributes_for(:medication, name: "")
  }

  before do
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe "GET #index" do
    it "returns a successful response and assigns medications" do
      get :index, params: { pet_id: pet.id }
      
      expect(response).to be_successful
      expect(assigns(:medications)).to include(medication)
      expect(response).to render_template(:index)
    end
  end

  describe "GET #new" do
    it "returns a successful response and assigns a new medication" do
      get :new, params: { pet_id: pet.id }
      
      expect(response).to be_successful
      expect(assigns(:medication)).to be_a_new(Medication)
      expect(assigns(:medication).pet).to eq(pet)
      expect(response).to render_template(:new)
    end
  end

  describe "GET #edit" do
    it "returns a successful response and assigns the correct medication" do
      get :edit, params: { pet_id: pet.id, id: medication.id }
      
      expect(response).to be_successful
      expect(assigns(:medication)).to eq(medication)
      expect(response).to render_template(:edit)
    end
  end

  describe "POST #create" do
    context "with valid parameters" do
      it "creates a new Medication" do
        expect {
          post :create, params: { pet_id: pet.id, medication: valid_attributes }
        }.to change(Medication, :count).by(1)
      end

      it "redirects to the user page with a notice" do
        post :create, params: { pet_id: pet.id, medication: valid_attributes }
        
        expect(response).to redirect_to(user_path(user))
        expect(flash[:notice]).to eq('Medicamento adicionado com sucesso')
      end
    end

    context "with invalid parameters" do
      it "does not create a new Medication" do
        expect {
          post :create, params: { pet_id: pet.id, medication: invalid_attributes }
        }.to_not change(Medication, :count)
      end

      it "re-renders the 'new' template with unprocessable_content status" do
        post :create, params: { pet_id: pet.id, medication: invalid_attributes }
        
        expect(response).to render_template(:new)
        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

  describe "PATCH #update" do
    let(:new_attributes) { { name: "Remédio de Orelha" } }

    context "with valid parameters" do
      before do
        patch :update, params: { pet_id: pet.id, id: medication.id, medication: new_attributes }
      end

      it "updates the requested medication" do
        medication.reload
        expect(medication.name).to eq("Remédio de Orelha")
      end

      it "redirects to the user page with a notice" do
        expect(response).to redirect_to(user_path(user))
        expect(flash[:notice]).to eq('Medicamento atualizado com sucesso.')
      end
    end

    context "with invalid parameters" do
      before do
        patch :update, params: { pet_id: pet.id, id: medication.id, medication: invalid_attributes }
      end
      
      it "does not update the medication" do
        original_name = medication.name
        medication.reload
        expect(medication.name).to eq(original_name)
      end

      it "re-renders the 'edit' template" do
        expect(response).to render_template(:edit)
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested medication" do
      expect {
        delete :destroy, params: { pet_id: pet.id, id: medication.id }
      }.to change(Medication, :count).by(-1)
    end

    it "redirects to the user page with a notice" do
      delete :destroy, params: { pet_id: pet.id, id: medication.id }
      
      expect(response).to redirect_to(user_path(user))
      expect(flash[:notice]).to eq('Medicamento excluído com sucesso.')
    end
  end
end