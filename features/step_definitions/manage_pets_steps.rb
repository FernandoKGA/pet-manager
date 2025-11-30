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

When('I click the button {string}') do |button|
  click_button button
end


Then('I should see the updated information in my pets page') do
  expect(page).to have_content("Pet atualizado com sucesso!")
  expect(page).to have_content("Luna Updated")
end

# Cenário: Remover informações de um pet
When('I click the delete link for that pet') do
  visit user_path(@user)

  # Abre o modal de exclusão do pet específico
  find("button[data-bs-target='#deletePetModal-#{@pet.id}']").click

  # Confirma a exclusão no modal
  within("#deletePetModal-#{@pet.id}") do
    click_button "Sim, excluir"
  end
end

Then('I should not see that pet in my pets page anymore') do
  visit user_path(@user)
  expect(page).not_to have_content(@pet.name)
end

Given('it has a photo') do
  file_path = Rails.root.join('spec/fixtures/files/bee.png')
  
  uploaded_file = Rack::Test::UploadedFile.new(file_path, 'image/png')
  
  @pet.attach_uploaded_file(uploaded_file)
  @pet.save!
end

When('I check {string}') do |field_label|
  check field_label
end

Then('it should not have a pet photo') do
  within(".pet-avatar") do
    expect(page).not_to have_css('img')
  end
end