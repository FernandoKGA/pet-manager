class AddActiveToPets < ActiveRecord::Migration[7.1]
  def change
    add_column :pets, :active, :boolean, default: true, null: false
    add_index :pets, :active
  end
end
