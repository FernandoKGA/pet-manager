Given("there is a pet named {string}") do |name|
  user = FactoryBot.create(:user)
  @pet = FactoryBot.create(:pet, name: name, user: user)
end

When('I visit the medical appointments page for {string}') do |_pet_name|
  visit pet_medical_appointments_path(@pet)
end

And("I fill in the medical appointment form with valid information") do
  fill_in "Nome do Veterinário", :with => "Dra. Marcia"
  fill_in "Data e hora da Consulta", :with => "2025-10-19T14:30"
  fill_in "Endereço da Clínica", :with => "Rua das Flores, 123"
  fill_in "Observação", :with => "Vou levar o Oliver."
end

When('I click the red button {string}') do |button_text|
 click_button(button_text)
end

When('I click the orange button {string}') do |button_text|
 click_button(button_text)
end

When('I change the veterinarian to {string}') do |new_name|
 visit edit_pet_medical_appointment_path(@pet, @medical_appointments) 
 fill_in 'Nome do Veterinário', with: new_name
end

When('I am deleting the query') do
 visit pet_medical_appointment_path(@pet)
 click_link 'Excluir', match: :first
end

