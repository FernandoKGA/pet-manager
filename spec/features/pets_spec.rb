require 'rails_helper'

RSpec.feature "Pets", type: :feature do
  let!(:user) do
    User.create!(
      email: "teste@teste.com",
      password: "tester",
      first_name: "teste",
      last_name: "teste"
    )
  end

  scenario "user logs in and creates a new pet successfully" do
    # --- login real ---
    visit login_path
    fill_in "Email", with: user.email
    fill_in "Senha", with: user.password
    click_button "Logar"

    # verifica se entrou no dashboard
    expect(page).to have_content("Bem-vindo #{user.first_name}")

    # --- navega para o form de cadastro de pets ---
    visit new_pet_path

    fill_in "Nome", with: "Rex"
    fill_in "Espécie", with: "Cachorro"
    fill_in "Raça", with: "Labrador"
    fill_in "Data de Nascimento", with: "2020-01-01"
    fill_in "Tamanho", with: 50
    fill_in "Gênero", with: "Macho"
    fill_in "ID Sinpatinhas", with: "12345"

    click_button "Salvar"

    # --- validações ---
    expect(page).to have_content("Pet cadastrado com sucesso!")
    expect(page).to have_content("Rex")
    expect(page).to have_content("Cachorro")
  end

  scenario "user submits invalid pet data" do
    # login
    visit login_path
    fill_in "Email", with: user.email
    fill_in "Senha", with: user.password
    click_button "Logar"

    # navega para o form
    visit new_pet_path

    fill_in "Nome", with: ""
    fill_in "Espécie", with: ""
    fill_in "Raça", with: ""

    click_button "Salvar"

    # valida se mostrou mensagem de erro
    expect(page).to have_content("Não foi possível guardar as informações do pet.")
  end
end
