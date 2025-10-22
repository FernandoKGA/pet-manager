# app/models/medication.rb

class Medication < ApplicationRecord
  belongs_to :pet
  
  validates :name, :dosage, :frequency, :start_date, presence: true
end
