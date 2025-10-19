# spec/system/expenses_dashboard_spec.rb
require 'rails_helper'

RSpec.describe "Dashboard de gastos", type: :system do
  let!(:user) { create(:user, email: "tester@capy.bara", password: "password", first_name: "Tester", last_name: "Capy") }
  let!(:pet) { create(:pet, user: user, name: "ACacoustic") }

  before do
    # Cria algumas despesas
    create(:expense, user: user, pet: pet, category: "veterinario", amount: 200, date: Date.today)
    create(:expense, user: user, pet: pet, category: "alimentacao", amount: 100, date: Date.today - 10)

    # Simula login para todos os requests (sem precisar passar pela tela)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
  end

  it "exibe o gráfico e os filtros" do
    visit expenses_path
    expect(page).to have_content("Minhas finanças")
    expect(page).to have_selector("#chart")
    expect(page).to have_select("Pet")
    expect(page).to have_select("Período")
  end

  it "abre modal de novo gasto" do
    visit expenses_path
    click_button "Adicionar gasto"

    expect(page).to have_selector("#expense-modal")
    fill_in "Valor", with: 120.5
    select "Veterinário", from: "Categoria"
    fill_in "Data", with: Date.today
    select "ACacoustic", from: "expense_pet_select"
    click_button "Salvar"

    expect(page).to have_content("Gasto registrado com sucesso")
  end

# entender bug com botao de retorno no teste capy

  
end

