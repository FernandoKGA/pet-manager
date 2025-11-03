module NotificationCenterContext
  extend ActiveSupport::Concern

  private

  def prepare_notification_center_context(user:, panel_open: nil, custom_reminder_form: nil)
    @notifications = user.reminder_notifications.includes(:pet).ordered_by_due_at
    @unread_count = user.reminder_notifications.unread.count

    default_panel_state = params[:notifications] == 'open' || params[:selected_notification_id].present?
    @notifications_panel_open = panel_open.nil? ? default_panel_state : panel_open

    selected_id = params[:selected_notification_id]&.to_i
    @selected_notification = @notifications.find { |item| item.id == selected_id } if selected_id

    @custom_reminder_form = custom_reminder_form
    @show_custom_reminder_modal = false

    if @custom_reminder_form.present?
      @show_custom_reminder_modal = true
    elsif params[:reminder_modal] == 'new'
      @custom_reminder_form = ReminderNotifications::CustomReminderForm.new(user:)
      @show_custom_reminder_modal = true
    end
  end
end
