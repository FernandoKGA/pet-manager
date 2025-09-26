# spec/helpers/sessions_helper_spec.rb
require 'rails_helper'

RSpec.describe SessionsHelper, type: :helper do
  let(:user) { FactoryBot.create(:user) }

  describe '#logged_in?' do
    context 'when no user is logged in' do
      it 'returns false' do
        expect(helper.logged_in?).to be_falsey
      end
    end

    context 'when a user is logged in' do
      before { helper.login(user) }

      it 'returns true' do
        expect(helper.logged_in?).to be_truthy
      end
    end
  end

  describe '#login' do
    it 'stores the user id in the session' do
      helper.login(user)
      expect(session[:user_id]).to eq(user.id)
    end
  end

  describe '#logout' do
    before do
      helper.login(user)
      helper.logout
    end

    it 'removes the user id from the session' do
      expect(session[:user_id]).to be_nil
    end

    it 'clears the memoized @current_user' do
      expect(helper.instance_variable_get(:@current_user)).to be_nil
    end
  end

  describe '#current_user' do
    context 'when session contains a valid user id' do
      before { session[:user_id] = user.id }

      it 'finds the user' do
        expect(helper.current_user).to eq(user)
      end

      it 'remembers the result and do not change the result if the user is updated' do
        first_call = helper.current_user

        user.update!(email: 'new@example.com')
        expect(helper.current_user).to equal(first_call)
      end
    end

    context 'when session does not contain a user id' do
      it 'returns nil' do
        expect(helper.current_user).to be_nil
      end
    end
  end
end
