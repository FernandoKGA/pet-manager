class AddEndDateToMedications < ActiveRecord::Migration[7.1]
  def change
    add_column :medications, :end_date, :date
  end
end
