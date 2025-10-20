FactoryBot.define do
  factory :reminder_notification do
    user

    title { 'Vacina V10 da Lira' }
    description { 'Dose anual da vacina V10 para a Lira' }
    category { 'Saúde' }
    status { :unread }
    due_at { 2.days.from_now }

    after(:build) do |notification|
      notification.pet ||= build(:pet, user: notification.user)
    end
  end
end
