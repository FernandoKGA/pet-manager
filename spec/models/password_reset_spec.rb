require 'rails_helper'

RSpec.describe PasswordReset, type: :model do
  # helpers para ActiveJob (testar deliver_later) e Time (testar expiração)
  include ActiveJob::TestHelper
  include ActiveSupport::Testing::TimeHelpers

  let(:user) { FactoryBot.create(:user) }
  let(:password_reset) { PasswordReset.new(email: user.email) }

  describe '#save' do
    context 'quando o email existe' do
      it 'atribui o usuário encontrado' do
        password_reset.save
        expect(password_reset.user).to eq(user)
      end

      it 'gera um token de reset para o usuário' do
        allow(SecureRandom).to receive(:urlsafe_base64).and_return('test_token')
        
        password_reset.save
        user.reload

        expect(user.password_reset_token).to eq('test_token')
      end

      it 'define a data de expiração do token para 24 horas' do
        freeze_time do
          password_reset.save
          user.reload

          expected_time = 24.hours.from_now
          expect(user.password_reset_token_expires_at).to be_within(1.second).of(expected_time)
        end
      end

      it 'enfileira o email de reset de senha' do
        expect {
          password_reset.save
        }.to have_enqueued_job(ActionMailer::MailDeliveryJob).with('UserMailer', 'password_reset', 'deliver_now', args: [user])
      end
    end

    context 'quando o email não existe' do
      let(:password_reset_invalid) { PasswordReset.new(email: 'not_found@example.com') }

      it 'não atribui um usuário' do
        password_reset_invalid.save
        expect(password_reset_invalid.user).to be_nil
      end

      it 'não levanta um erro (falha silenciosamente)' do
        expect {
          password_reset_invalid.save
        }.not_to raise_error
      end

      it 'não enfileira nenhum email' do
        expect {
          password_reset_invalid.save
        }.not_to have_enqueued_job(ActionMailer::MailDeliveryJob)
      end
    end
  end

  describe '.find_by_valid_token' do
    let!(:user_with_token) do
      FactoryBot.create(:user, 
        password_reset_token: 'valid_token', 
        password_reset_token_expires_at: 1.hour.from_now
      )
    end

    let!(:user_with_expired_token) do
      FactoryBot.create(:user, 
        password_reset_token: 'expired_token', 
        password_reset_token_expires_at: 1.hour.ago
      )
    end

    it 'encontra o usuário com um token válido e não expirado' do
      found_user = PasswordReset.find_by_valid_token('valid_token')
      expect(found_user).to eq(user_with_token)
    end

    it 'retorna nil para um token expirado' do
      found_user = PasswordReset.find_by_valid_token('expired_token')
      expect(found_user).to be_nil
    end

    it 'retorna nil para um token que não existe' do
      found_user = PasswordReset.find_by_valid_token('does_not_exist')
      expect(found_user).to be_nil
    end

    it 'retorna nil para um token nulo ou em branco' do
      expect(PasswordReset.find_by_valid_token(nil)).to be_nil
      expect(PasswordReset.find_by_valid_token('')).to be_nil
    end
  end
end