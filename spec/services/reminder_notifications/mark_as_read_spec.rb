require 'rails_helper'

RSpec.describe ReminderNotifications::MarkAsRead do
  subject(:service) { described_class.new(notification:, actor:) }

  let(:notification) { create(:reminder_notification, status: :unread) }
  let(:actor) { notification.user }

  describe '#call' do
    it 'marks the notification as read' do
      service.call

      expect(notification.reload).to be_read
    end

    it 'returns a success result with a toast message' do
      result = service.call

      expect(result).to be_success
      expect(result.toast).to eq("#{notification.pet.name} está em dia! ✅")
    end

    context 'when the notification belongs to another user' do
      let(:actor) { create(:user) }

      it 'raises an authorization error' do
        expect { service.call }.to raise_error(ReminderNotifications::AuthorizationError)
      end
    end

    context 'when the notification is already read' do
      let(:notification) { create(:reminder_notification, status: :read) }

      it 'keeps it as read and returns a neutral message' do
        result = service.call

        expect(notification.reload).to be_read
        expect(result.toast).to eq("#{notification.pet.name} está em dia! ✅")
      end
    end
  end
end
