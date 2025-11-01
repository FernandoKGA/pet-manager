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

end
