# app/models/medication.rb

class Medication < ApplicationRecord
  belongs_to :pet
  
  validates :name, :dosage, :frequency, :start_date, :end_date, presence: true
end
