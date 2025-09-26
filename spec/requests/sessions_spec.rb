require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  describe "GET /login" do
    it "returns http success" do
      get login_path
      expect(response).to have_http_status(:success)
    end

    it "redirects to show page if already logged" do
      user = FactoryBot.create(:user)
      post login_path, params: { session: { email: user.email, password: user.password } } #session only exists after request apparently

      get login_path
      expect(response).to redirect_to(user_path(user))
    end
  end

  describe "POST /login" do
    it "returns error when wrong credentials provided" do
      post login_path, params: { session: { email: 'test@email.com', password: '54321' } }
      expect(response).to redirect_to(login_path)

      expect(session[:user_id]).to be_nil
      expect(flash[:alert]).to eq("Algo deu errado! Por favor, verifique suas credenciais.")
    end

    it "logs the user and redirect to default page" do
      user = FactoryBot.create(:user)
      post login_path, params: { session: { email: user.email, password: user.password } }
      expect(response).to redirect_to(user_path(user))
      expect(session[:user_id]).to eq(user.id)
    end
  end

end
