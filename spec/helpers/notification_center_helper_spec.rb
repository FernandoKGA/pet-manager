require 'rails_helper'

RSpec.describe NotificationCenterHelper, type: :helper do
  include ActiveSupport::Testing::TimeHelpers

  around do |example|
    travel_to(Date.new(2024, 1, 10)) { example.run }
  end

  describe '#unread_pill_text' do
    it 'formats counts for zero, one, and many' do
      expect(helper.unread_pill_text(0)).to eq('0 não lidas')
      expect(helper.unread_pill_text(1)).to eq('1 não lida')
      expect(helper.unread_pill_text(5)).to eq('5 lembretes pendentes')
    end
  end

  describe '#notification_due_badge_class' do
    it 'returns info badge when record lacks due_at' do
      expect(helper.notification_due_badge_class(Object.new)).to eq('badge text-bg-info')
    end

    it 'returns danger badge when overdue' do
      record = double('Notification', due_at: Time.zone.parse('2024-01-05'))
      expect(helper.notification_due_badge_class(record)).to eq('badge text-bg-danger')
    end

    it 'returns info badge when upcoming' do
      record = double('Notification', due_at: Time.zone.parse('2024-01-12'))
      expect(helper.notification_due_badge_class(record)).to eq('badge text-bg-info')
    end
  end
end
