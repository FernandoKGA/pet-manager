class CreateWeights < ActiveRecord::Migration[7.1]
  def change
    create_table :weights do |t|
      t.references :pet, null: false, foreign_key: true
      t.decimal :weight

      t.timestamps
    end
  end
end
