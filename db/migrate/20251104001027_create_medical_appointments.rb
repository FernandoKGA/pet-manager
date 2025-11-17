class CreateMedicalAppointments < ActiveRecord::Migration[7.1]
  def change
    create_table :medical_appointments do |t|
      t.references :user, null: false, foreign_key: true
      t.references :pet, null: false, foreign_key: true
      t.string :veterinarian_name
      t.datetime :appointment_date
      t.string :clinic_address
      t.text :notes

      t.timestamps
    end
  end
end
