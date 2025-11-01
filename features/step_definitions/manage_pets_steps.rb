Given('I am a registered user') do
  @user = User.create!(
    email: "teste@teste.com",
    password: "tester",
    first_name: "teste",
    last_name: "teste"
  )
end

And('I am logged into my account') do
  visit login_path
  fill_in 'Email', with: @user.email
  fill_in 'Senha', with: 'tester'
  click_button 'Logar'
end

When('I navigate to the {string} page') do |page_name|
  case page_name
  when 'Add Pet'
    visit new_pet_path
  when 'Edit Pet'
    visit edit_pet_path(@pet)
  end
end

When('I navigate to the {string} page for that pet') do |page_name|
  case page_name
  when 'Edit Pet'
    visit edit_pet_path(@pet)
  end
end

And('I fill in the pet form with valid information') do
  fill_in 'Nome', with: 'Rex'
  fill_in 'Data de Nascimento', with: '2020-01-01'
  fill_in 'Tamanho', with: '50'
  fill_in 'Espécie', with: 'Cachorro'
  fill_in 'Raça', with: 'Labrador'
  fill_in 'Gênero', with: 'Macho'
  fill_in 'ID Sinpatinhas', with: '12345'
end

Then('I should see the new pet listed in my pets page') do
  # Verifica apenas se o pet foi criado - conteúdo principal
  expect(page).to have_content('Rex')
end

Given('I have an existing pet registered') do
  @pet = Pet.create!(
    name: 'Buddy',
    species: 'Cachorro',
    breed: 'Golden Retriever',
    birthdate: '2019-05-15',
    size: 60,
    gender: 'Macho',
    sinpatinhas_id: '54321',
    user: @user
  )
end

And('I update the pet information with valid data') do
  fill_in 'Nome', with: 'Buddy Updated'
  fill_in 'Espécie', with: 'Cachorro'
  fill_in 'Raça', with: 'Golden Retriever'
  fill_in 'Tamanho', with: '65'
end


Then('I should see the updated information in my pets page') do
  # Verifica apenas se o nome foi atualizado
  expect(page).to have_content('Buddy Updated')
end