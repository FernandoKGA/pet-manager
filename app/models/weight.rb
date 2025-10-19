class Weight < ApplicationRecord
  belongs_to :pet

  validates :weight, presence: true, numericality: { greater_than: 0 }
end
