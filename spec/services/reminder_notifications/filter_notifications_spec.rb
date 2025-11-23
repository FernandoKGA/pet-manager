require 'rails_helper'

RSpec.describe ReminderNotifications::FilterNotifications do
  subject(:service) { described_class.new(user:) }

  include ActiveSupport::Testing::TimeHelpers

  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:today) { Date.new(2024, 1, 10) }

  around do |example|
    travel_to(today) { example.run }
  end

  describe '#call' do
    let!(:unread_health_today) do
      create(:reminder_notification, user:, status: :unread, category: 'Saúde', due_at: today.in_time_zone.end_of_day)
    end

    let!(:unread_vet_in_3_days) do
      create(:reminder_notification, user:, status: :unread, category: 'Veterinário', due_at: (today + 3.days).in_time_zone.end_of_day)
    end

    let!(:read_hygiene_in_5_days) do
      create(:reminder_notification, user:, status: :read, category: 'Higiene', due_at: (today + 5.days).in_time_zone.end_of_day)
    end

    let!(:read_food_in_12_days) do
      create(:reminder_notification, user:, status: :read, category: 'Compras', due_at: (today + 12.days).in_time_zone.end_of_day)
    end

    let!(:other_user_notification) do
      create(:reminder_notification, user: other_user, status: :unread, category: 'Saúde', due_at: today.in_time_zone.end_of_day)
    end

    it 'returns all user notifications ordered by due date when no filters are provided' do
      result = service.call

      expect(result).to eq([unread_health_today, unread_vet_in_3_days, read_hygiene_in_5_days, read_food_in_12_days])
      expect(result).not_to include(other_user_notification)
    end

    it 'filters by status' do
      result = service.call(status: 'unread')

      expect(result).to match_array([unread_health_today, unread_vet_in_3_days])
    end

    it 'filters by category' do
      result = service.call(category: 'Higiene')

      expect(result).to match_array([read_hygiene_in_5_days])
    end

    it 'filters by due date range inclusive' do
      result = service.call(due_from: today, due_to: today + 10.days)

      expect(result).to match_array([unread_health_today, unread_vet_in_3_days, read_hygiene_in_5_days])
    end

    it 'applies multiple filters together' do
      result = service.call(status: 'unread', category: 'Saúde', due_from: today, due_to: today + 1.day)

      expect(result).to match_array([unread_health_today])
    end

    it 'accepts localized read status' do
      result = service.call(status: 'Lidas')

      expect(result).to match_array([read_hygiene_in_5_days, read_food_in_12_days])
    end

    it 'ignores unknown status values' do
      result = service.call(status: 'unknown')

      expect(result).to match_array([unread_health_today, unread_vet_in_3_days, read_hygiene_in_5_days, read_food_in_12_days])
    end

    it 'filters by starting date only' do
      result = service.call(due_from: today + 4.days)

      expect(result).to match_array([read_hygiene_in_5_days, read_food_in_12_days])
    end

    it 'filters by end date only' do
      result = service.call(due_to: today + 3.days)

      expect(result).to match_array([unread_health_today, unread_vet_in_3_days])
    end
  end
end
