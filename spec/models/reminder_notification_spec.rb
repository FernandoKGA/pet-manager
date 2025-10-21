require 'rails_helper'

RSpec.describe ReminderNotification, type: :model do
  include ActiveSupport::Testing::TimeHelpers
  subject(:notification) { build(:reminder_notification, due_at: due_at) }

  let(:due_at) { Time.zone.parse('2024-07-10 10:00:00') }

  describe 'validations' do
    it 'is valid with required attributes' do
      expect(notification).to be_valid
    end

    it 'requires a title' do
      notification.title = nil
      expect(notification).not_to be_valid
      expect(notification.errors[:title]).to include("can't be blank")
    end

    it 'requires a user' do
      notification.user = nil
      expect(notification).not_to be_valid
      expect(notification.errors[:user]).to include('must exist')
    end

    it 'requires a pet' do
      notification.pet = nil
      expect(notification).not_to be_valid
      expect(notification.errors[:pet]).to include('must exist')
    end

    it 'requires a category' do
      notification.category = nil
      expect(notification).not_to be_valid
      expect(notification.errors[:category]).to include("can't be blank")
    end

    it 'requires a due date' do
      notification.due_at = nil
      expect(notification).not_to be_valid
      expect(notification.errors[:due_at]).to include("can't be blank")
    end
  end

  describe '#due_label' do
    around do |example|
      Time.use_zone('UTC') { example.run }
    end

    before do
      travel_to(Time.zone.parse('2024-07-10 09:00:00'))
    end

    after do
      travel_back
    end

    it 'returns "Hoje" for notifications due today' do
      notification.due_at = Time.zone.parse('2024-07-10 18:00:00')
      expect(notification.due_label).to eq('Hoje')
    end

    it 'returns "Em 3 dias" for notifications due in the next days' do
      notification.due_at = Time.zone.parse('2024-07-13 12:00:00')
      expect(notification.due_label).to eq('Em 3 dias')
    end

    it 'returns "Ontem" when the reminder expired one day ago' do
      notification.due_at = Time.zone.parse('2024-07-09 12:00:00')
      expect(notification.due_label).to eq('Ontem')
    end

    it 'returns "Há 2 dias" when the reminder expired more than one day ago' do
      notification.due_at = Time.zone.parse('2024-07-08 12:00:00')
      expect(notification.due_label).to eq('Há 2 dias')
    end
  end
end
