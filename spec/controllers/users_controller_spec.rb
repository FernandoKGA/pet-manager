require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  describe 'GET #new' do
    it "retorna uma resposta de sucesso" do
      get :new

      expect(response).to be_successful
      expect(response).to have_http_status(:ok)
    end

    it "renderiza o template :new corretamente" do
      get :new

      expect(response).to render_template(:new)
    end
  end

  describe 'post #create' do
    let(:valid_info)    { { user: { email: 'teste@petmanager.com', first_name: 'Teste', last_name: 'da Silva', password: 'teste', password_confirmation: 'teste' } } }

    context 'dados válidos' do
      it "cria um novo usuário no banco de dados" do
        expect {
          post :create, params: valid_info
        }.to change(User, :count).by(1)
      end

      it "deve retornar sucesso" do
        post :create, params: valid_info
        
        expect(response).to redirect_to('/login')
      end

    end
  end
end