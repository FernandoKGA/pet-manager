require 'rails_helper'

RSpec.describe ReminderNotifications::CreateCustomReminder do
  let(:user) { create(:user) }
  let(:pet) { create(:pet, user:) }
  let(:due_at) { Time.zone.local(2024, 5, 10, 9, 0, 0) }
  let(:recurrence_key) { 'none' }

  let(:notification_attributes) do
    {
      user: user,
      pet_id: pet.id,
      title: 'Comprar ração premium',
      category: 'Compras',
      description: 'Comprar 2 sacos',
      due_at: due_at,
      recurrence: recurrence_key
    }
  end

  let(:form) do
    instance_double(
      ReminderNotifications::CustomReminderForm,
      to_notification_attributes: notification_attributes,
      due_at: due_at,
      recurrence_key: recurrence_key
    )
  end

  subject(:service) { described_class.new(form:) }

  describe '#call' do
    it 'persists the reminder notification' do
      expect { service.call }.to change(ReminderNotification, :count).by(1)

      notification = ReminderNotification.last
      expect(notification.title).to eq(notification_attributes[:title])
      expect(notification.category).to eq(notification_attributes[:category])
      expect(notification.pet).to eq(pet)
      expect(notification.user).to eq(user)
      expect(notification.due_at).to eq(due_at)
      expect(notification.recurrence).to eq('none')
      expect(notification.description).to eq('Comprar 2 sacos')
    end

    it 'returns a success result with the default toast message' do
      result = service.call

      expect(result).to be_success
      expect(result.toast).to eq('Lembrete cadastrado com sucesso! 🎯')
    end

    it 'exposes the created notification' do
      service.call

      expect(service.notification).to be_a(ReminderNotification)
      expect(service.notification.title).to eq(notification_attributes[:title])
    end

    context 'when the reminder is daily' do
      let(:recurrence_key) { 'daily' }
      let(:due_at) { Time.zone.local(2024, 5, 10, 21, 0, 0) }

      let(:notification_attributes) do
        super().merge(due_at: due_at, recurrence: recurrence_key)
      end

      it 'saves the recurrence and returns a recurrence-specific toast' do
        result = service.call

        expect(result.toast).to eq('Vamos te lembrar todos os dias às 21h. 💊')
        expect(ReminderNotification.last.recurrence).to eq('daily')
      end
    end

    context 'when there are no notes' do
      it 'stores a blank description' do
        allow(form).to receive(:to_notification_attributes).and_return(notification_attributes.merge(description: nil))

        expect { service.call }.to change(ReminderNotification, :count).by(1)
        expect(ReminderNotification.last.description).to be_nil
      end
    end
  end
end
