class CreateReminderNotifications < ActiveRecord::Migration[7.1]
  def change
    create_table :reminder_notifications do |t|
      t.references :user, null: false, foreign_key: true
      t.references :pet, null: false, foreign_key: true
      t.string :title, null: false
      t.text :description
      t.string :category, null: false
      t.integer :status, null: false, default: 0
      t.datetime :due_at, null: false

      t.timestamps null: false
    end

    add_index :reminder_notifications, %i[user_id status]
    add_index :reminder_notifications, :due_at
  end
end
