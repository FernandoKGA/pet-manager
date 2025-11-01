class AddRecurrenceToReminderNotifications < ActiveRecord::Migration[7.1]
  def change
    add_column :reminder_notifications, :recurrence, :string, null: false, default: 'none'
  end
end
