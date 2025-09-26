require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  let(:user) { create(:user, email: 'user@example.com', password: 'password') }

  describe 'GET #new' do
    context 'when user is logged in' do
      before do
        allow(controller).to receive(:logged_in?).and_return(true)
        allow(controller).to receive(:current_user).and_return(user)
        get :new
      end

      it 'redirects to the user’s profile page' do
        expect(response).to redirect_to(user_path(user))
      end
    end

    context 'when no user is logged in' do
      before do
        allow(controller).to receive(:logged_in?).and_return(false)
        get :new
      end

      it 'renders the new template' do
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'POST #create' do
    let(:valid_params) { { session: { email: user.email.downcase, password: 'password' } } }
    let(:invalid_params) { { session: { email: 'wrong@example.com', password: 'badpass' } } }

    context 'with valid credentials' do
      before do
        allow(controller).to receive(:login).and_call_original
        post :create, params: valid_params
      end

      it 'calls the login helper' do
        expect(controller).to have_received(:login).with(user)
      end

      it 'redirects to the user’s profile page' do
        expect(response).to redirect_to(user_path(user))
      end
    end

    context 'with invalid credentials' do
      before do
        post :create, params: invalid_params
      end

      it 'does not call the login helper' do
        expect(controller).not_to receive(:login)
      end

      it 'redirects back to the login page' do
        expect(response).to redirect_to(login_path)
      end

      it 'sets an alert flash message' do
        expect(flash[:alert]).to eq('Algo deu errado! Por favor, verifique suas credenciais.')
      end
    end
  end
end