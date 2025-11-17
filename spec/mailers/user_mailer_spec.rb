require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe "password_reset" do
    let(:user) do
      instance_double(User,
                      email: "usuario@teste.com",
                      password_reset_token: "token_simulado_123")
    end

    let(:mail) { UserMailer.password_reset(user) }

    it "renderiza os cabeçalhos corretamente" do
      expect(mail.subject).to eq("Trocar sua senha")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['noreply@petmanager.herokuapp.com'])
    end

    it "renderiza o corpo do e-mail" do
      expect(mail.body.encoded).to match("Trocar minha senha")
      
      expect(mail.body.encoded).to match(user.password_reset_token)
    end
  end
end