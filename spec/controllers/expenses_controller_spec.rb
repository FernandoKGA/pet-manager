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
          post :create, params: { expense: { amount: nil, category: '', date: '', pet_id: nil } }
        }.to_not change(Expense, :count)

        expect(response).to redirect_to(expenses_path)
        expect(flash[:notice]).to eq('Seu gasto não foi registrado. Verifique os dados e tente novamente.')
      end
    end
  end
end