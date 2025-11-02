class Vaccination < ApplicationRecord
  belongs_to :pet

  validates :vaccine_name, presence: true, length: { maximum: 255 }
  validates :administered_on, presence: true

  scope :upcoming, -> { where.not(next_due_on: nil).where('next_due_on >= ?', Time.zone.today).order(:next_due_on) }
end
