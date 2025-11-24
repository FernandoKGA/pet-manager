require 'rails_helper'

RSpec.describe NotificationCenter::CustomRemindersController, type: :controller do
  let(:user) { create(:user) }
  let(:pet)  { create(:pet, user: user) }

  let(:valid_form_params) do
    {
      title: 'Comprar ração',
      pet_id: pet.id,
      category: 'Saúde',
      scheduled_date: Date.current + 1.day,
      time: '10:30',
      recurrence: 'Não repetir',
      notes: '10kg'
    }
  end

  before do
    allow(controller).to receive(:logged_in?).and_return(true)
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe 'GET #new' do
    it 'redirects to the user dashboard with the new reminder modal open' do
      get :new

      expect(response).to redirect_to(user_path(user, notifications: 'open', reminder_modal: 'new'))
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'persists the reminder and redirects with toast' do
        expect do
          post :create, params: { reminder_notifications_custom_reminder_form: valid_form_params }
        end.to change(ReminderNotification, :count).by(1)

        expect(flash[:notice]).to eq('Lembrete cadastrado com sucesso! 🎯')
        expect(response).to redirect_to(user_path(user, notifications: 'open'))
      end
    end

    context 'with invalid params' do
      it 're-renders the user page with the modal open and alert' do
        post :create, params: { reminder_notifications_custom_reminder_form: valid_form_params.merge(title: '') }

        expect(response).to have_http_status(:unprocessable_content)
        expect(response).to render_template('users/show')
        expect(assigns(:notifications_panel_open)).to be(true)
        expect(assigns(:custom_reminder_form)).to be_present
        expect(assigns(:show_custom_reminder_modal)).to be(true)
        expect(flash.now[:alert]).to eq('Não foi possível salvar o lembrete. Verifique os campos destacados.')
      end
    end
  end
end
