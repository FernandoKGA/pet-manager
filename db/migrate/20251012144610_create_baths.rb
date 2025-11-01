class CreateBaths < ActiveRecord::Migration[7.1]
  def change
    create_table :baths do |t|
      t.references :pet, null: false, foreign_key: true
      t.datetime :date
      t.decimal :price
      t.text :notes

      t.timestamps
    end
  end
end
