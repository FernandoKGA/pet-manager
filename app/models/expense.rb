class Expense < ApplicationRecord
  belongs_to :user
  belongs_to :pet

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :category, presence: true
  validates :date, presence: true
end
