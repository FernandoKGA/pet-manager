class Pet < ApplicationRecord
  validates :name, presence: true, length: {maximum: 255}
  validates :species, presence: true, length: {maximum: 255}
  validates :breed, presence: true, length: {maximum: 255}

  belongs_to :user

  has_many :reminder_notifications, dependent: :destroy
  has_many :expenses, dependent: :destroy
  has_many :weights, dependent: :destroy
  has_many :diary_entries, dependent: :destroy

  def current_weight
    weights.order(created_at: :desc).first&.weight
  end
end
