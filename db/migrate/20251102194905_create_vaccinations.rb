class CreateVaccinations < ActiveRecord::Migration[7.1]
  def change
    create_table :vaccinations do |t|
      t.string :name
      t.date :applied_date
      t.string :applied_by
      t.boolean :applied
      t.references :pet, null: false, foreign_key: true

      t.timestamps
    end
  end
end
