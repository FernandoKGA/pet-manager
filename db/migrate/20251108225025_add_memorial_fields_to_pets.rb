class AddMemorialFieldsToPets < ActiveRecord::Migration[7.0]
  def change
    add_column :pets, :deceased, :boolean, default: false, null: false
    add_column :pets, :date_of_death, :date
    
    add_index :pets, :deceased
    add_index :pets, :date_of_death
  end
end