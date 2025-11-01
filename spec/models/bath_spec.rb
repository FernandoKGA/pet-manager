require 'rails_helper'

RSpec.describe Bath, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:pet) { FactoryBot.create(:pet, user: user) }

  # Falha 1: Associações
  describe 'Associações' do
    it 'pertence a um Pet' do
      bath = Bath.new(pet: pet, date: Time.now, price: 10.00)
      expect(bath.pet).to eq(pet)
    end
    
    it 'é inválido sem um Pet' do
      bath = Bath.new(date: Time.now, price: 10.00)
      expect(bath).to_not be_valid
      # Verifica a mensagem de erro da associação obrigatória
      expect(bath.errors[:pet]).to include("must exist")
    end
  end

  # Falhas 2 e 3: Validações
  describe 'Validações' do
    
    # Falha 2: Teste de presença da data
    it 'é inválido sem data' do
      bath = Bath.new(pet: pet, date: nil, price: 10.00)
      expect(bath).to_not be_valid
      expect(bath.errors[:date]).to include("Campo data obrigatório.")
    end

    # Falha 3: Teste de validação de preço (numericality e > 0)
    it 'é inválido se o preço for negativo' do
      bath = Bath.new(pet: pet, date: Time.now, price: -1.0)
      expect(bath).to_not be_valid
      expect(bath.errors[:price]).to be_present # ou inclua a mensagem exata
    end

    # Falha 4: Garante que é válido com todos os campos necessários
    it 'é válido com todos os atributos necessários' do
      bath = Bath.new(pet: pet, date: Time.now, price: 50.00)
      expect(bath).to be_valid
    end
  end
end
