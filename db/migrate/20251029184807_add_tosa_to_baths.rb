class AddTosaToBaths < ActiveRecord::Migration[7.1]
  def change
    add_column :baths, :tosa, :boolean, default: false
  end
end
