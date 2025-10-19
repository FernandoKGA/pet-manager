require 'rails_helper'

RSpec.describe NotificationCenterController, type: :controller do
  let(:user) { create(:user) }
  let(:pet)  { create(:pet, user: user) }
  let(:notification) { create(:reminder_notification, user: user, pet: pet, status: :unread) }

  before do
    allow(controller).to receive(:logged_in?).and_return(true)
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe 'authentication' do
    it 'redirects unauthenticated users to login with alert' do
      allow(controller).to receive(:logged_in?).and_return(false)
      allow(controller).to receive(:current_user).and_return(nil)

      get :index

      expect(response).to redirect_to(login_path)
      expect(flash[:alert]).to eq('Faça login para acessar a central de notificações')
    end
  end

  describe 'GET #index' do
    it 'redirects to the user dashboard with notifications open' do
      get :index

      expect(response).to redirect_to(user_path(user, notifications: 'open', anchor: 'notification-center-card'))
    end
  end

  describe 'GET #show' do
    let(:service_double) { instance_double(ReminderNotifications::MarkAsRead, call: service_result) }
    let(:service_result) { ReminderNotifications::Result.new(success: true, toast: 'toast') }

    before do
      allow(ReminderNotifications::MarkAsRead).to receive(:new).and_return(service_double)
    end

    it 'marks unread notifications and redirects with selected notification id' do
      get :show, params: { id: notification.id }

      expect(ReminderNotifications::MarkAsRead).to have_received(:new).with(notification: notification, actor: user)
      expect(service_double).to have_received(:call)
      expect(response).to redirect_to(user_path(user, notifications: 'open', selected_notification_id: notification.id, anchor: 'notification-center-card'))
    end

    it 'skips service when notification already read' do
      notification.update!(status: :read)

      get :show, params: { id: notification.id }

      expect(ReminderNotifications::MarkAsRead).not_to have_received(:new)
      expect(response).to redirect_to(user_path(user, notifications: 'open', selected_notification_id: notification.id, anchor: 'notification-center-card'))
    end

    it 'handles record not found with alert' do
      get :show, params: { id: 'invalid' }

      expect(response).to redirect_to(user_path(user, notifications: 'open', anchor: 'notification-center-card'))
      expect(flash[:alert]).to eq('Lembrete não encontrado.')
    end
  end

  describe 'PATCH #mark_as_read' do
    let(:service_double) { instance_double(ReminderNotifications::MarkAsRead) }
    let(:service_result) { ReminderNotifications::Result.new(success: true, toast: 'Tudo lido!') }

    before do
      allow(ReminderNotifications::MarkAsRead).to receive(:new).and_return(service_double)
      allow(service_double).to receive(:call).and_return(service_result)
    end

    it 'invokes the service and sets notice' do
      patch :mark_as_read, params: { id: notification.id }

      expect(ReminderNotifications::MarkAsRead).to have_received(:new).with(notification: notification, actor: user)
      expect(service_double).to have_received(:call)
      expect(flash[:notice]).to eq('Tudo lido!')
      expect(response).to redirect_to(user_path(user, notifications: 'open', anchor: 'notification-center-card'))
    end

    it 'rescues authorization errors with alert' do
      allow(service_double).to receive(:call).and_raise(ReminderNotifications::AuthorizationError)

      patch :mark_as_read, params: { id: notification.id }

      expect(flash[:alert]).to eq('Você não tem acesso a este lembrete.')
      expect(response).to redirect_to(user_path(user, notifications: 'open', anchor: 'notification-center-card'))
    end
  end

  describe 'PATCH #mark_all_as_read' do
    let(:service_result) { ReminderNotifications::Result.new(success: true, toast: 'Tudo certo! Você está em dia com os lembretes.', updated_count: updated_count) }
    let(:service_double) { instance_double(ReminderNotifications::MarkAllAsRead, call: service_result) }
    let(:updated_count) { 2 }

    before do
      allow(ReminderNotifications::MarkAllAsRead).to receive(:new).and_return(service_double)
    end

    it 'sets notice to toast when updates occur' do
      patch :mark_all_as_read

      expect(ReminderNotifications::MarkAllAsRead).to have_received(:new).with(user: user)
      expect(service_double).to have_received(:call)
      expect(flash[:notice]).to eq('Tudo certo! Você está em dia com os lembretes.')
      expect(response).to redirect_to(user_path(user, notifications: 'open', anchor: 'notification-center-card'))
    end

    it 'uses fallback message when nothing updated' do
      allow(service_double).to receive(:call).and_return(ReminderNotifications::Result.new(success: true, toast: 'ignored', updated_count: 0))

      patch :mark_all_as_read

      expect(flash[:notice]).to eq('Nenhum lembrete precisava ser atualizado.')
    end
  end
end
