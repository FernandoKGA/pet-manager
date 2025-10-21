require 'rails_helper'

RSpec.describe ReminderNotifications::MarkAllAsRead do
  subject(:service) { described_class.new(user:) }

  let(:user) { create(:user) }

  describe '#call' do
    let!(:unread_notifications) do
      create_list(:reminder_notification, 2, user: user, status: :unread)
    end

    let!(:read_notification) do
      create(:reminder_notification, user: user, status: :read)
    end

    let!(:other_user_notification) do
      create(:reminder_notification, status: :unread)
    end

    it 'marks only the user unread notifications as read' do
      service.call

      expect(unread_notifications.map(&:reload).all?(&:read?)).to be(true)
      expect(read_notification.reload).to be_read
      expect(other_user_notification.reload).to be_unread
    end

    it 'returns a result with a success toast' do
      result = service.call
      expect(result).to be_success
      expect(result.toast).to eq('Tudo certo! Você está em dia com os lembretes.')
    end

    it 'returns how many notifications were updated' do
      result = service.call
      expect(result.updated_count).to eq(2)
    end
  end
end
