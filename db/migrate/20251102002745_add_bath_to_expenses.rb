class AddBathToExpenses < ActiveRecord::Migration[7.1]
  def change
    add_reference :expenses, :bath, foreign_key: true
  end
end
