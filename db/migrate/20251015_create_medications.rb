# db/migrate/20251015_create_medications.rb
class CreateMedications < ActiveRecord::Migration[6.0]
  def change
    create_table :medications do |t|
      t.references :pet, null: false, foreign_key: true
      t.string :name, null: false
      t.string :dosage, null: false
      t.string :frequency, null: false
      t.date :start_date, null: false
      t.text :description

      t.timestamps
    end
  end
end