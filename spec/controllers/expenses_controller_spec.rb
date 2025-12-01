require 'rails_helper'

RSpec.describe ExpensesController, type: :controller do
  let(:user) { create(:user) }
  let(:pet) { create(:pet, user: user) }

  before do
    allow(controller).to receive(:authenticate_user)
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe "GET #index" do
    # Criar um segundo pet para testar o filtro de pet
    let(:pet2) { create(:pet, user: user) }

    # Criar um conjunto de dados para testar os filtros
    let!(:exp_pet1_today) { create(:expense, user: user, pet: pet, date: Date.today, category: 'alimentacao', amount: 10) }
    let!(:exp_pet2_today) { create(:expense, user: user, pet: pet2, date: Date.today, category: 'veterinario', amount: 50) }
    let!(:exp_pet1_2_weeks) { create(:expense, user: user, pet: pet, date: 2.weeks.ago.to_date, category: 'brinquedos', amount: 20) }
    let!(:exp_pet1_2_months) { create(:expense, user: user, pet: pet, date: 2.months.ago.to_date, category: 'alimentacao', amount: 15) }
    let!(:exp_pet1_2_years) { create(:expense, user: user, pet: pet, date: 2.years.ago.to_date, category: 'outros', amount: 100) }

    it "renderiza o template index e atribui todas as despesas" do
      get :index
      expect(response).to render_template(:index)
      expect(assigns(:pets)).to contain_exactly(pet, pet2)
      expect(assigns(:expenses)).to contain_exactly(
        exp_pet1_today, exp_pet2_today, exp_pet1_2_weeks, exp_pet1_2_months, exp_pet1_2_years
      )
    end

    it "filtra por pet_id" do
      get :index, params: { pet_id: pet2.id }

      expect(assigns(:expenses)).to contain_exactly(exp_pet2_today)
    end

    it "filtra por período 'Última semana'" do
      get :index, params: { period: "Última semana" }

      expect(assigns(:expenses)).to contain_exactly(exp_pet1_today, exp_pet2_today)
    end

    it "filtra por período 'Último mês'" do
      get :index, params: { period: "Último mês" }

      expect(assigns(:expenses)).to contain_exactly(
        exp_pet1_today, exp_pet2_today, exp_pet1_2_weeks
      )
    end

    it "filtra por período 'Último ano'" do
      get :index, params: { period: "Último ano" }

      expect(assigns(:expenses)).to contain_exactly(
        exp_pet1_today, exp_pet2_today, exp_pet1_2_weeks, exp_pet1_2_months
      )
    end

    it "filtra por pet_id e período combinados" do
      get :index, params: { pet_id: pet.id, period: "Último mês" }

      expect(assigns(:expenses)).to contain_exactly(exp_pet1_today, exp_pet1_2_weeks)
    end

    it "calcula @chart_data corretamente (sem filtros)" do
      get :index
      expected_chart_data = {
        'alimentacao' => 25.0,  # 10 + 15
        'veterinario' => 50.0,
        'brinquedos' => 20.0,
        'outros' => 100.0
      }
      expect(assigns(:chart_data)).to eq(expected_chart_data)
    end
  end

  describe "POST #create" do
    context "com parâmetros válidos" do
      it "cria um novo gasto e redireciona" do
        expect {
          post :create, params: { expense: { amount: 120.5, category: 'veterinario', date: Date.today, pet_id: pet.id } }
        }.to change(Expense, :count).by(1)

        expect(response).to redirect_to(expenses_path)
        expect(flash[:notice]).to eq('Gasto registrado com sucesso')
      end
    end

    context "com parâmetros inválidos" do
      it "falha ao criar gasto e redireciona com aviso" do
        expect {
          post :create, params: { expense: { amount: nil, category: '', date: '', pet_id: pet.id } }
        }.to_not change(Expense, :count)

        expect(response).to render_template(:index)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "GET #edit" do
    let!(:expense) { create(:expense, user: user, pet: pet, amount: 80.0, category: 'outros', date: Date.today) }

    it "renderiza index com o modal aberto" do
      get :edit, params: { id: expense.id }

      expect(response).to render_template(:index)
      expect(assigns(:expense)).to eq(expense)
      expect(assigns(:open_modal)).to be_truthy
    end
  end

  describe "PATCH #update" do
    let!(:expense) { create(:expense, user: user, pet: pet, amount: 150.0, category: 'alimentacao', date: Date.today) }

    context "com parâmetros válidos" do
      it "atualiza o gasto e redireciona" do
        patch :update, params: { id: expense.id, expense: { amount: 200.0 } }

        expect(expense.reload.amount).to eq(200.0)
        expect(response).to redirect_to(expenses_path)
        expect(flash[:notice]).to eq('Gasto atualizado com sucesso')
      end
    end

    context "com parâmetros inválidos" do
      it "não atualiza o gasto e mantém o modal aberto" do
        patch :update, params: { id: expense.id, expense: { amount: nil } }

        expect(expense.reload.amount).to eq(150.0)
        expect(response).to render_template(:index)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(assigns(:open_modal)).to be_truthy
      end
    end
  end
end

  describe "DELETE #destroy" do
    let!(:expense) { create(:expense, user: user, pet: pet, amount: 50.0, category: 'outros', date: Date.today) }

    it "remove o gasto e redireciona" do
      expect {
        delete :destroy, params: { id: expense.id }
      }.to change(Expense, :count).by(-1)

      expect(response).to redirect_to(expenses_path)
      expect(flash[:notice]).to eq('Gasto excluído com sucesso')
    end
  end
end
