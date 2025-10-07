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
          post :create, params: { expense: { amount: 120.5, category: 'Saúde', date: Date.today, pet_id: pet.id } }
        }.to change(Expense, :count).by(1)

        expect(response).to redirect_to(expenses_path)
      end
    end

    context "com parâmetros inválidos" do
      it "não cria o gasto e renderiza :new" do
        expect {
          post :create, params: { expense: { amount: nil, category: '', date: '', pet_id: nil } }
        }.to_not change(Expense, :count)

        expect(response).to render_template(:new)
      end
    end
  end
end
