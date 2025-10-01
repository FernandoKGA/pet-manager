class CreatePets < ActiveRecord::Migration[7.1]
  def change
    create_table :pets do |t|
      t.string :name
      t.date :birthdate
      t.integer :size
      t.string :species
      t.string :breed
      t.string :gender
      t.string :sinpatinhas_id

      t.belongs_to :user, foreign_key: true

      t.timestamps
    end
  end
end
