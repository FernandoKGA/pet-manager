class RemoveUserFromMedicalAppointments < ActiveRecord::Migration[7.1]
  def change
    remove_reference :medical_appointments, :user, null: false, foreign_key: true
  end
end
