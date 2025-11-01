# features/step_definitions/add_pet_weight_steps.rb

And('I have added a pet') do
  visit new_pet_path
  fill_in 'Nome', with: 'Rex'
  fill_in 'Espécie', with: 'Cachorro'
  fill_in 'Raça', with: 'Labrador'
  fill_in 'Data de Nascimento', with: '2020-01-01'
  fill_in 'Tamanho', with: '50'
  fill_in 'Gênero', with: 'Macho'
  fill_in 'ID Sinpatinhas', with: '12345'
  
  # ALTERADO: Usar o texto correto do botão
  click_button 'Registrar Pet'
  
  # Verificar se o pet foi criado com sucesso
  expect(page).to have_content('Pet cadastrado com sucesso!')
  
  # Armazenar o pet criado para uso posterior
  @pet = Pet.last
end

When('I click in the link {string}') do |link_text|
  click_link link_text
end

Then('I should see the notice {string}') do |notice|
  expect(page).to have_content(notice)
end