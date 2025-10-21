require 'rails_helper'

RSpec.describe WeightController, type: :controller do
  let(:user) { create(:user, password: "senha123") }
  let(:pet) { create(:pet, user: user) }

  before do
    session[:user_id] = user.id
  end

  describe 'GET #new' do
    it 'sucesso e renderiza a página new' do
      get :new, params: { pet_id: pet.id }
      expect(response).to be_successful
      expect(response).to render_template(:new)
    end

    it 'atribui um novo peso' do
      get :new, params: { pet_id: pet.id }
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

      it 'redireciona para a página do pet com uma mensagem de sucesso' do
        post :create, params: valid_params
        expect(response).to redirect_to(user_path(user))
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

      it 're-renderiza a página do pet com uma mensagem de erro' do
        post :create, params: invalid_params

        expect(response).to redirect_to(user_path(user))
        expect(flash[:alert]).to eq("Weight can't be blank")
      end
    end
  end
end