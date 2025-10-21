class CreateDiaryEntries < ActiveRecord::Migration[7.1]
  def change
    create_table :diary_entries do |t|
      t.text :content
      t.datetime :entry_date
      t.references :pet, null: false, foreign_key: true

      t.timestamps
    end
  end
end
