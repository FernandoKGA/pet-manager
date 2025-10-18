require 'rails_helper'

RSpec.describe ExpensesController, type: :controller do
  let(:user) { create(:user) }
  let(:pet) { create(:pet, user: user) }  

  before do
    allow(controller).to receive(:authenticate_user)
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe "POST #create" do
    context "com parâmetros válidos" do
      it "cria um novo gasto e redireciona" do
        expect {
          post :create, params: { expense: { amount: 120.5, category: 'veterinario', date: Date.today, pet_id: pet.id } }
        }.to change(Expense, :count).by(1)

        expect(response).to redirect_to(expenses_path)
      end
    end

    context "com parâmetros inválidos" do
      it "falha ao criar gasto e redireciona com aviso" do
        expect {
          post :create, params: { expense: { amount: nil, category: '', date: '', pet_id: nil } }
        }.to_not change(Expense, :count)

        expect(response).to redirect_to(expenses_path)
        expect(flash[:notice]).to eq('Seu gasto não foi registrado. Verifique os dados e tente novamente.')
      end
    end
  end
end
