class Medication < ApplicationRecord
  belongs_to :pet
  
  validates :name, :dosage, :frequency, :start_date, :end_date, presence: true
  validate :end_date_cannot_be_before_start_date

  private

  def end_date_cannot_be_before_start_date
    return if end_date.blank? || start_date.blank?

    if end_date < start_date
      errors.add("Data Fim não pode ser anterior à data de início")
    end
  end
end
