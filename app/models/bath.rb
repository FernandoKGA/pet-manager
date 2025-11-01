class Bath < ApplicationRecord
  belongs_to :pet

  before_validation :normalize_price

  validates :price, numericality: true

  private

  def normalize_price
    return if price.blank?
    # Substitui vírgula por ponto
    self.price = price.to_s.tr(',', '.').to_f
  end

  # Adicionar validações
  validates :date, presence: { message: "Campo data obrigatório." }
  validates :price, numericality: { greater_than_or_equal_to: 0 }

  # PM-38
  after_commit :create_expense_record, on: :create
  before_destroy :destroy_expense_record
 
  private

  def create_expense_record
   Expense.create!(
     user: pet.user, # ← associa automaticamente o usuário dono do pet
     pet: pet,
     description: "Banho do pet #{pet.name}",
     amount: price,
     category: "higiene",
     date: date || Time.current
   )
  end

    def destroy_expense_record
    Expense.find_by(
      user: pet.user,
      pet: pet,
      amount: price,
      category: "higiene",
      description: "Banho do pet #{pet.name}",
      date: date
    )&.destroy
  end
end