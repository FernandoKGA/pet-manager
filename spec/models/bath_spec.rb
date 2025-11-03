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

  describe "callbacks de despesa" do
    it "cria uma despesa automaticamente ao criar um banho" do
      bath = Bath.create!(pet: pet, date: Time.zone.now, price: 50.00)

      expect(bath.expense).to be_present
      expect(bath.expense.amount).to eq(50.00)
      expect(bath.expense.category).to eq("higiene")
      expect(bath.expense.pet).to eq(pet)
      expect(bath.expense.user).to eq(user)
    end

    it "atualiza a despesa quando o preço do banho é alterado" do
      bath = Bath.create!(pet: pet, date: Time.zone.now, price: 50.00)
      bath.update!(price: 75.00)

      expect(bath.expense.reload.amount).to eq(75.00)
    end

    it "atualiza a despesa quando a data do banho é alterada" do
      bath = Bath.create!(pet: pet, date: Time.zone.now, price: 50.00)
      new_date = 2.days.from_now
      bath.update!(date: new_date)

      expect(bath.expense.reload.date.to_date).to eq(new_date.to_date)
    end

    it "exclui a despesa associada ao excluir o banho" do
      bath = Bath.create!(pet: pet, date: Time.zone.now, price: 50.00)
      expense_id = bath.expense.id

      bath.destroy

      expect(Expense.find_by(id: expense_id)).to be_nil
    end
  end

end
