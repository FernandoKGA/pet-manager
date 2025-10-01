# features/step_definitions/manage_pets_steps.rb

Given('I am a registered user') do
  @user = User.create!(
    email: "petowner@example.com",
    password: "password123",
    first_name: "Pet",
    last_name: "Owner"
  )
end

Given('I am logged into my account') do
  visit "/login"
  fill_in "Email", with: @user.email
  fill_in "Senha", with: "password123"
  click_button "Logar"
  expect(page).to have_content("Estamos felizes em ter você AUqui")
end

# Cenário: Adicionar informações de um novo pet
When('I navigate to the {string} page') do |page|
  case page
  when "Add Pet"
    visit new_pet_path
  else
    raise "Unknown page: #{page}"
  end
end

When('I navigate to the {string} page for that pet') do |page|
  case page
  when "Edit Pet"
    visit edit_pet_path(@pet)
  else
    raise "Unknown page: #{page}"
  end
end

When('I fill in the pet form with valid information') do
  fill_in "Nome", with: "Rex"
  fill_in "Espécie", with: "Dog"
  fill_in "Data de Nascimento", with: "2020-01-15"
  fill_in "Tamanho", with: "10"
  fill_in "Raça", with: "Labrador"
  fill_in "Gênero", with: "Macho"
end

When('I submit the new pet form') do
  click_button "Salvar"
end

When(/^I press "([^"]*)"$/) do |button|
  click_button button
end

Then('I should see the new pet listed in my pets page') do
  expect(page).to have_content("Pet cadastrado com sucesso!")
  expect(page).to have_content("Rex")
  expect(page).to have_content("Dog")
end

# Cenário: Atualizar informações de um pet existente
Given('I have an existing pet registered') do
  @pet = Pet.create!(
    name: "Luna",
    species: "Cat",
    birthdate: Date.new(2019, 5, 10),
    size: 5,
    breed: "Siamese",
    gender: "Fêmea",
    user: @user
  )
end

When('I update the pet information with valid data') do
  fill_in "Nome", with: "Luna Updated"
  fill_in "Data de Nascimento", with: "2019-06-15"
  fill_in "Tamanho", with: "6"
end

When('I submit the updated pet form') do
  click_button "Atualizar"
end

Then('I should see the updated information in my pets page') do
  expect(page).to have_content("Pet atualizado com sucesso!")
  expect(page).to have_content("Luna Updated")
end

# Cenário: Remover informações de um pet
When('I click the {string} button for that pet') do |button|
  visit user_path(@user)
  # Assumindo que existe um botão ou link de delete próximo ao pet
  # Você precisará ajustar conforme a implementação real da sua view
  click_link button, match: :first
end

Then('I should not see that pet in my pets page anymore') do
  visit user_path(@user)
  expect(page).not_to have_content(@pet.name)
end