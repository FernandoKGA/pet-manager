require 'rails_helper'

RSpec.describe WeightsController, type: :controller do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user, email: 'test2@petmanager.com') }
  let!(:pet) { create(:pet, user: user) }
  let(:current_user) { user }

  before do
    allow(controller).to receive(:authenticate_user)
    allow(controller).to receive(:current_user).and_return(current_user)
  end

  describe 'GET #index' do
    it 'carrega os pesos do pet' do
      weight = create(:weight, pet: pet, weight: 30.5)

      get :index, params: { pet_id: pet.id }

      expect(response).to be_successful
      expect(assigns(:weights)).to include(weight)
      expect(assigns(:chart_data)).to be_present
    end

    context 'quando o usuário não é o tutor' do
      let(:current_user) { other_user }

      it 'redireciona quando o usuário não é o tutor' do
        get :index, params: { pet_id: pet.id }

        expect(response).to redirect_to(pets_path)
        expect(flash[:alert]).to eq('Somente o tutor pode registrar novos pesos.')
      end
    end
  end

  describe 'GET #new' do
    it 'permite acesso ao tutor' do
      get :new, params: { pet_id: pet.id }
      expect(response).to be_successful
      expect(assigns(:weight)).to be_a_new(Weight)
    end
  end

  describe 'POST #create' do
    context 'com parâmetros válidos' do
      let(:valid_params) { { pet_id: pet.id, weight: { weight: 30.5 } } }

      it 'cria um novo peso' do
        expect {
          post :create, params: valid_params
        }.to change(Weight, :count).by(1)
      end

      it 'redireciona para o histórico com aviso' do
        post :create, params: valid_params
        expect(response).to redirect_to(pet_weights_path(pet))
        expect(flash[:notice]).to eq('Peso atualizado com sucesso.')
      end
    end

    context 'com parâmetros inválidos' do
      let(:invalid_params) { { pet_id: pet.id, weight: { weight: '' } } }

      it 'não cria um novo peso' do
        expect {
          post :create, params: invalid_params
        }.not_to change(Weight, :count)
      end

      it 'redireciona com mensagem de erro' do
        post :create, params: invalid_params

        expect(response).to redirect_to(pet_weights_path(pet))
        expect(flash[:alert]).to eq("Weight can't be blank")
      end
    end

    context 'quando o usuário não é o tutor' do
      let(:current_user) { other_user }

      it 'impede a criação' do
        expect {
          post :create, params: { pet_id: pet.id, weight: { weight: 30.5 } }
        }.not_to change(Weight, :count)

        expect(response).to redirect_to(pet_weights_path(pet))
        expect(flash[:alert]).to eq('Somente o tutor pode registrar novos pesos.')
      end
    end
  end
end
