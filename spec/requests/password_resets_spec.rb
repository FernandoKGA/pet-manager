require 'rails_helper'

RSpec.describe "PasswordResets", type: :request do
  let(:user) { FactoryBot.create(:user) }

  describe "GET /password_resets/new" do
    it "renderiza o template 'new' com sucesso" do
      get new_password_reset_path
      expect(response).to have_http_status(:ok)
      expect(response).to render_template(:new)
    end
  end

  describe "POST /password_resets" do
    it "chama o modelo PasswordReset e redireciona para o login" do
      # Impede que o modelo real seja chamado
      password_reset_double = instance_double(PasswordReset)
      
      # Esperamos que PasswordReset.new seja chamado com os parâmetros corretos
      allow(PasswordReset).to receive(:new).with(hash_including("email" => user.email)).and_return(password_reset_double)
      
      allow(password_reset_double).to receive(:save)
      post password_resets_path, params: { password_reset: { email: user.email } }
      expect(password_reset_double).to have_received(:save)
      
      expect(response).to redirect_to(login_path)
      expect(flash[:notice]).to eq("Um link para trocar sua senha foi enviado ao seu email.")
    end
  end

  describe "GET /password_resets/:id/edit" do
    context "com um token válido" do
      it "renderiza o template 'edit'" do
        allow(PasswordReset).to receive(:find_by_valid_token).with("valid_token").and_return(user)

        get edit_password_reset_path("valid_token")

        expect(response).to have_http_status(:ok)
        expect(response).to render_template(:edit)
      end
    end

    context "com um token inválido ou expirado" do
      it "redireciona para a página 'new' e mostra um alerta" do
        allow(PasswordReset).to receive(:find_by_valid_token).with("invalid_token").and_return(nil)

        get edit_password_reset_path("invalid_token")

        expect(response).to redirect_to(new_password_reset_path)
        expect(flash[:alert]).to eq("Seu link de trocar de senha não é válido.")
      end
    end
  end

  describe "PATCH /password_resets/:id" do
    let(:valid_params) do
      { user: { password: "new_password123", password_confirmation: "new_password123" } }
    end

    context "com um token inválido ou expirado" do
      it "redireciona para a página 'new'" do
        allow(PasswordReset).to receive(:find_by_valid_token).with("invalid_token").and_return(nil)

        patch password_reset_path("invalid_token"), params: valid_params

        expect(response).to redirect_to(new_password_reset_path)
        expect(flash[:error]).to eq("Seu link de trocar de senha não é válido.")
      end
    end

    context "com um token válido" do
      # Mock no user para alterar `.update`
      let(:mock_user) { instance_double(User) }
      
      before do
        allow(PasswordReset).to receive(:find_by_valid_token).with("valid_token").and_return(mock_user)
      end

      context "com parâmetros de usuário válidos" do
        it "atualiza o usuário, redireciona para o login e mostra um aviso" do
          # Esperamos que o usuário receba a chamada de 'update'
          allow(mock_user).to receive(:update).with(
            hash_including("password" => "new_password123", "password_confirmation" => "new_password123")
          ).and_return(true)

          patch password_reset_path("valid_token"), params: valid_params

          expect(mock_user).to have_received(:update)
          expect(response).to redirect_to(login_path)
          expect(flash[:notice]).to eq("Sua senha foi atualizada.")
        end
      end

      context "com parâmetros de usuário inválidos (ex: senhas não batem)" do
        it "não atualiza o usuário e renderiza 'edit' novamente" do
          allow(mock_user).to receive(:update).and_return(false)

          patch password_reset_path("valid_token"), params: { user: { password: "1", password_confirmation: "2" } }
          
          expect(mock_user).to have_received(:update)
          expect(response).to have_http_status(:unprocessable_content)
          expect(response).to render_template(:edit)
          expect(flash.now[:alert]).to eq("Ocorreu um erro atualizando sua senha.")
        end
      end
    end
  end
end