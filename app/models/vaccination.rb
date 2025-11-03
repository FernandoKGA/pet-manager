class Vaccination < ApplicationRecord
  belongs_to :pet

  validates :name, presence: true
  validates :applied_date, presence: true
end
