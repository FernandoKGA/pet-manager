class User < ApplicationRecord
  has_secure_password

  enum role: { owner: 0, veterinarian: 1 }

  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: { case_sensitive: false }
  validates :first_name, presence: true, length: {maximum: 255}
  validates :last_name, presence: true, length: {maximum: 255}

  before_validation :set_default_role, on: :create

  has_many :pets, dependent: :destroy
  
  has_many :reminder_notifications, dependent: :destroy

  has_many :expenses, dependent: :destroy

  private

  def set_default_role
    self.role ||= :owner
  end
end
