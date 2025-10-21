class Expense < ApplicationRecord
  belongs_to :user
  belongs_to :pet

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :category, presence: true
  validates :date, presence: true

  CATEGORIES = %w[alimentacao veterinario higiene brinquedos outros]
  validates :category, inclusion: { in: CATEGORIES, message: "%{value} não é uma categoria válida" }
end
