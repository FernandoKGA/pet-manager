require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  describe 'GET #new' do
    it "returns success response" do
      get :new

      expect(response).to be_successful
      expect(response).to have_http_status(:ok)
    end

    it "render the template :new correctly" do
      get :new

      expect(response).to render_template(:new)
    end
  end

  describe 'post #create' do
    let(:valid_info)    { { user: { email: 'teste@petmanager.com', first_name: 'Teste', last_name: 'da Silva', password: 'teste', password_confirmation: 'teste' } } }
    let(:invalid_pass)    { { user: { email: 'teste@petmanager.com', first_name: 'Teste', last_name: 'da Silva', password: 'teste123', password_confirmation: 'test' } } }

    context 'valid data' do
      it "create a new user in database" do
        expect {
          post :create, params: valid_info
        }.to change(User, :count).by(1)
      end

      it "should return success" do
        post :create, params: valid_info
        
        expect(response).to redirect_to('/login')
      end
    end

    context 'passwords do not match' do
      it 'should not create the user' do
        expect {
          post :create, params: invalid_pass
        }.to_not change(User, :count) 
      end
      
      it 'should refresh the page' do
        expect(response).to render_template(:new)
      end
    end
  end
end