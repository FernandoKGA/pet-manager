require 'rails_helper'

RSpec.describe ReminderNotifications::CustomReminderForm do
  include ActiveSupport::Testing::TimeHelpers

  subject(:form) { described_class.new(user:) }

  let(:user) { create(:user) }
  let!(:pet) { create(:pet, user:) }

  describe '#submit' do
    let(:params) do
      {
        title: 'Comprar ração premium',
        pet_id: pet.id,
        category: 'Compras',
        scheduled_date: Time.zone.tomorrow,
        time: '09:00',
        recurrence: 'Não repetir',
        notes: 'Comprar 2 sacos'
      }
    end

    it 'returns true when the payload is valid' do
      result = form.submit(params)

      expect(result).to be(true)
      expect(form).to be_valid
    end

    it 'builds the due_at value based on the chosen date option' do
      travel_to(Time.zone.local(2024, 5, 10, 8, 0, 0)) do
        form.submit(params)

        expect(form.due_at).to eq(Time.zone.local(2024, 5, 11, 9, 0, 0))
      end
    end

    it 'maps the recurrence key for persistence' do
      form.submit(params.merge(recurrence: 'Diariamente', time: '21:00'))

      expect(form.recurrence_key).to eq('daily')
    end

    it 'exposes the attributes ready for the service layer' do
      travel_to(Time.zone.local(2024, 5, 10, 8, 0, 0)) do
        form.submit(params)

        expect(form.to_notification_attributes).to include(
          user: user,
          pet_id: pet.id,
          title: 'Comprar ração premium',
          category: 'Compras',
          description: 'Comprar 2 sacos',
          recurrence: 'none',
          due_at: Time.zone.local(2024, 5, 11, 9, 0, 0)
        )
      end
    end

    it 'adds user-friendly errors for missing data' do
      form.submit(params.merge(title: '', pet_id: nil, scheduled_date: nil))

      expect(form.errors[:title]).to include('Informe um título para o lembrete')
      expect(form.errors[:pet_id]).to include('Selecione um pet para vincular o lembrete')
      expect(form.errors[:scheduled_date]).to include('Escolha uma data válida')
    end

    it 'validates that the pet belongs to the user' do
      other_pet = create(:pet)
      form.submit(params.merge(pet_id: other_pet.id))

      expect(form.errors[:pet_id]).to include('Selecione um pet válido')
    end

    it 'rejects dates in the past' do
      form.submit(params.merge(scheduled_date: Time.zone.yesterday))

      expect(form.errors[:scheduled_date]).to include('Escolha uma data válida')
    end
  end
end
