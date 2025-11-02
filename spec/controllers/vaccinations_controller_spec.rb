require 'rails_helper'

RSpec.describe VaccinationsController, type: :controller do
  let!(:user) { create(:user) }
  let!(:pet) { create(:pet, user: user) }
  
  let!(:other_user) { create(:user) }
  let!(:other_pet) { create(:pet, user: other_user) }

  let!(:vaccination) { create(:vaccination, pet: pet) }
  
  let(:valid_attributes) { attributes_for(:vaccination, applied_by: 'Dr. Vet') }
  let(:invalid_attributes) { attributes_for(:vaccination, :invalid) }

  before do
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe 'GET #index' do
    it 'assigns all vaccinations for the pet as @vaccinations' do
      get :index, params: { pet_id: pet.id }
      expect(response).to be_successful
      expect(response).to render_template(:index)
      expect(assigns(:vaccinations)).to eq([vaccination])
    end
    
    it 'raises RecordNotFound when accessing another user\'s pet' do
      expect {
        get :index, params: { pet_id: other_pet.id }
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe 'GET #new' do
    it 'assigns a new vaccination as @vaccination' do
      get :new, params: { pet_id: pet.id }
      expect(response).to be_successful
      expect(response).to render_template(:new)
      expect(assigns(:vaccination)).to be_a_new(Vaccination)
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested vaccination as @vaccination' do
      get :edit, params: { pet_id: pet.id, id: vaccination.id }
      expect(response).to be_successful
      expect(response).to render_template(:edit)
      expect(assigns(:vaccination)).to eq(vaccination)
    end
  end
  
  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Vaccination' do
        expect {
          post :create, params: { pet_id: pet.id, vaccination: valid_attributes }
        }.to change(Vaccination, :count).by(1)
      end

      it 'redirects to the vaccinations index' do
        post :create, params: { pet_id: pet.id, vaccination: valid_attributes }
        expect(response).to redirect_to(pet_vaccinations_path(pet))
      end
    end

    context 'with invalid params' do
      it 'does not create a new Vaccination' do
        expect {
          post :create, params: { pet_id: pet.id, vaccination: invalid_attributes }
        }.to_not change(Vaccination, :count)
      end

      it 're-renders the :new template with unprocessable_content status' do
        post :create, params: { pet_id: pet.id, vaccination: invalid_attributes }
        expect(response).to render_template(:new)
        expect(response.status).to eq(422)
        expect(flash.now[:danger]).to eq("Não foi possível salvar as informações de vacinação do pet.")
      end
    end
  end
  
  describe 'PATCH #update' do
    context 'with valid params' do
      let(:new_attributes) { { name: 'Raiva' } }

      it 'updates the requested vaccination' do
        patch :update, params: { pet_id: pet.id, id: vaccination.id, vaccination: new_attributes }
        vaccination.reload
        expect(vaccination.name).to eq('Raiva')
      end

      it 'redirects to the vaccinations index' do
        patch :update, params: { pet_id: pet.id, id: vaccination.id, vaccination: new_attributes }
        expect(response).to redirect_to(pet_vaccinations_path(pet))
      end
    end

    context 'with invalid params' do
      it 're-renders the :edit template' do
        patch :update, params: { pet_id: pet.id, id: vaccination.id, vaccination: invalid_attributes }
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested vaccination' do
      expect {
        delete :destroy, params: { pet_id: pet.id, id: vaccination.id }
      }.to change(Vaccination, :count).by(-1)
    end

    it 'redirects to the vaccinations list' do
      delete :destroy, params: { pet_id: pet.id, id: vaccination.id }
      expect(response).to redirect_to(pet_vaccinations_path(pet))
    end
  end
end