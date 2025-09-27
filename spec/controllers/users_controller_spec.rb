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
    let(:invalid_pass)    { { user: { email: 'teste@petmanager.com', first_name: 'Teste', last_name: 'da Silva', password: 'teste', password_confirmation: 'test' } } }

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

    context 'senhas não coincidem' do
      it 'deve retornar uma mensagem de erro' do
        expect {
          post :create, params: invalid_pass
        }.to_not change(User, :count) 

        expect(response).to have_http_status(:unprocessable_content)
        expect(response).to render_template(:new)
      end
    end
  end
end