require 'rails_helper'

RSpec.describe NotificationCenterContext, type: :controller do
  include ActiveSupport::Testing::TimeHelpers

  controller(ApplicationController) do
    include NotificationCenterContext

    def index
      form = params[:use_custom_form] ? ReminderNotifications::CustomReminderForm.new(user: current_user) : nil
      prepare_notification_center_context(user: current_user, panel_open: params[:panel_open], custom_reminder_form: form)
      render plain: 'ok'
    end
  end

  let(:user) { create(:user) }
  let(:pet) { create(:pet, user: user) }
  let!(:notification) { create(:reminder_notification, user: user, pet: pet, due_at: Time.zone.today.in_time_zone.end_of_day) }

  around do |example|
    travel_to(Date.new(2024, 1, 10)) { example.run }
  end

  before do
    routes.draw { get 'anonymous/index' => 'anonymous#index' }
    allow(controller).to receive(:logged_in?).and_return(true)
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe '#prepare_notification_center_context' do
    it 'sets the modal open when a custom form is provided and keeps panel open' do
      get :index, params: { use_custom_form: true, notifications: 'open', selected_notification_id: notification.id }

      expect(assigns(:notifications_panel_open)).to be(true)
      expect(assigns(:custom_reminder_form)).to be_a(ReminderNotifications::CustomReminderForm)
      expect(assigns(:show_custom_reminder_modal)).to be(true)
      expect(assigns(:selected_notification)).to eq(notification)
    end

    it 'instantiates a form when reminder_modal param is new' do
      get :index, params: { reminder_modal: 'new' }

      expect(assigns(:custom_reminder_form)).to be_a(ReminderNotifications::CustomReminderForm)
      expect(assigns(:show_custom_reminder_modal)).to be(true)
    end

    it 'builds filter tags and summary from params' do
      get :index, params: {
        status_filter: 'Lidas',
        category_filter: 'Saúde',
        due_from: 'Hoje',
        due_to: 'Em 1 semana'
      }

      expect(assigns(:active_filter_tags)).to include('Status: Lidas', 'Categoria: Saúde')
      expect(assigns(:active_filter_summary)).to include('Hoje até Em 7 dias')
      expect(assigns(:filter_selections)).to include(status: 'read')
    end
  end

  describe '#parse_filter_date' do
    it 'parses relative day strings' do
      expect(controller.send(:parse_filter_date, 'Amanhã')).to eq(Date.new(2024, 1, 11))
      expect(controller.send(:parse_filter_date, 'Ontem')).to eq(Date.new(2024, 1, 9))
      expect(controller.send(:parse_filter_date, 'Em 3 dias')).to eq(Date.new(2024, 1, 13))
      expect(controller.send(:parse_filter_date, 'Em 2 semanas')).to eq(Date.new(2024, 1, 24))
    end

    it 'parses explicit dates and ignores invalid ones' do
      expect(controller.send(:parse_filter_date, '2024-02-01')).to eq(Date.new(2024, 2, 1))
      expect(controller.send(:parse_filter_date, 'not a date')).to be_nil
    end
  end

  describe 'filter labeling helpers' do
    it 'maps status labels and summaries' do
      expect(controller.send(:normalize_status_filter, 'Não lidas')).to eq('unread')
      expect(controller.send(:status_tag_label, 'unread')).to eq('Não lidas')
      expect(controller.send(:status_tag_label, 'read')).to eq('Lidas')
    end

    it 'builds period tags with defaults' do
      from = Date.new(2024, 1, 10)
      to = Date.new(2024, 1, 17)
      expect(controller.send(:period_tag_label, from, to)).to eq('Hoje até Em 7 dias')
    end

    it 'formats date labels across ranges' do
      expect(controller.send(:date_label, nil)).to be_nil
      expect(controller.send(:date_label, Date.new(2024, 1, 10))).to eq('Hoje')
      expect(controller.send(:date_label, Date.new(2024, 1, 11))).to eq('Amanhã')
      expect(controller.send(:date_label, Date.new(2024, 1, 9))).to eq('Ontem')
      expect(controller.send(:date_label, Date.new(2024, 2, 5))).to eq('Em 26 dias')
      expect(controller.send(:date_label, Date.new(2023, 12, 20))).to eq('Há 21 dias')
      far_future = Date.new(2024, 3, 10)
      expect(controller.send(:date_label, far_future)).to eq(I18n.l(far_future, format: :short))
    end

    it 'joins active tags when present and returns nil when empty' do
      expect(controller.send(:build_active_filter_summary, ['Status: Lidas', 'Categoria: Saúde'])).to eq('Status: Lidas • Categoria: Saúde')
      expect(controller.send(:build_active_filter_summary, [])).to be_nil
    end
  end
end
