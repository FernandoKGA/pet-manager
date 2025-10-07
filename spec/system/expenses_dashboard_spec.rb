require 'rails_helper'

RSpec.describe "Dashboard de gastos", type: :system do
  let(:user) { create(:user) }
  let!(:pet) { create(:pet, user: user, name: "Rex") }

  before do
    create(:expense, user: user, pet: pet, category: "Saúde", amount: 200, date: Date.today)
    create(:expense, user: user, pet: pet, category: "Comida", amount: 100, date: Date.today - 10)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
  end

  it "exibe o gráfico e os filtros" do
    visit expenses_path

    expect(page).to have_content("Meus Gastos")
    expect(page).to have_selector("#chart") 
    expect(page).to have_select("Pet")
    expect(page).to have_select("Período")
  end

  it "abre modal de novo gasto" do
    visit expenses_path
    click_button "Adicionar gasto"

    expect(page).to have_selector("#expense-modal")
    fill_in "Valor", with: 120.5
    fill_in "Categoria", with: "Vacina"
    fill_in "Data", with: Date.today
    select "Rex", from: "Pet"
    click_button "Salvar"

    expect(page).to have_content("Gasto registrado com sucesso")
  end

  it "permite voltar à dashboard" do
    visit expenses_path
    click_link "Voltar"
    expect(current_path).to eq(user_path(user))
  end
end
