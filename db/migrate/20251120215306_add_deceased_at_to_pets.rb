class AddDeceasedAtToPets < ActiveRecord::Migration[7.1]
  def change
    add_column :pets, :deceased_at, :datetime
  end
end
