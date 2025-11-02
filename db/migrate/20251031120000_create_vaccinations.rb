class CreateVaccinations < ActiveRecord::Migration[7.1]
  def change
    create_table :vaccinations do |t|
      t.references :pet, null: false, foreign_key: true
      t.string :vaccine_name, null: false
      t.date :administered_on, null: false
      t.date :next_due_on
      t.string :dose
      t.string :manufacturer
      t.string :batch_number
      t.text :notes

      t.timestamps
    end

    add_index :vaccinations, [:pet_id, :administered_on]
    add_index :vaccinations, :next_due_on
  end
end
