class Bath < ApplicationRecord
  belongs_to :pet

  # Associação com despesas (Expense)
  has_one :expense, dependent: :destroy

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
  after_create :create_expense_record

  after_update :update_expense_record
 
  private

  def create_expense_record
   Expense.create!(
     user: pet.user, # ← associa automaticamente o usuário dono do pet
     pet: pet,
     bath: self,
     description: "Banho do pet #{pet.name}",
     amount: price,
     category: "higiene",
     date: date || Time.current
   )
  end

  def update_expense_record
    return unless expense.present?

    expense.update(
      amount: price,
      date: date
    )
  end

    scope :between_dates, ->(from, to) {
    return all if from.blank? && to.blank?


    # Converte strings para date/datetime com segurança
    begin
      if from.present? && to.present?
        where(date: Date.parse(from).beginning_of_day..Date.parse(to).end_of_day)
      elsif from.present?
        where('date >= ?', Date.parse(from).beginning_of_day)
      elsif to.present?
        where('date <= ?', Date.parse(to).end_of_day)
      else
        all
      end
    rescue ArgumentError
      # Se parse falhar, não filtra
      none
    end
  }

  scope :with_tosa, ->(tosa_value) {
    return all if tosa_value.blank? || tosa_value == 'all'

    # tosa_value esperado 'true' ou 'false' (strings)
    where(tosa: ActiveModel::Type::Boolean.new.cast(tosa_value))
  }
end