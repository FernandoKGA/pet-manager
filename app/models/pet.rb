class Pet < ApplicationRecord
  validates :name, presence: true, length: {maximum: 255}
  validates :species, presence: true, length: {maximum: 255}
  validates :breed, presence: true, length: {maximum: 255}
  
  belongs_to :user
end
