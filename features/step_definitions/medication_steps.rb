# features/step_definitions/medication_steps.rb

Given('I am a registered user') do
  @user = create(:user, email: 'test@example.com', password: 'password123')
end

Given('I am logged into my account') do
  visit '/users/sign_in'
  fill_in 'session_email', with: @user.email
  fill_in 'session_password', with: @user.password
  click_button 'commit'
end

Given('I have at least one pet registered') do
  @pet = create(:pet, user: @user)
  visit root_path
end

When('I click on the medication button {string}') do |button_text|
  case button_text
  when 'Adicionar Medicamento'
    visit new_pet_medication_path(@pet)
  else
    click_button button_text
  end
end

When('I press the medication button {string}') do |button_text|
  click_button button_text
end

When('I click the medication save button') do
  click_button 'Criar Medicamento'
end

When('I click the medication update button') do
  click_button 'Atualizar'
end

When('I enter the medication name {string}') do |name|
  fill_in 'Nome do Medicamento', with: name
end

When('I enter the medication dosage {string}') do |dosage|
  fill_in 'Dosagem', with: dosage
end

When('I enter the medication frequency {string}') do |frequency|
  fill_in 'Frequência', with: frequency
end

When('I enter the medication start date {string}') do |date|
  fill_in 'Data de Início', with: date
end

When('I enter the medication end date {string}') do |date|
  fill_in 'Data de Fim', with: date
end

When('I do not enter a medication end date') do
  fill_in 'Data de Fim', with: ''
end

When('I update the medication dosage to {string}') do |dosage|
  fill_in 'Dosagem', with: dosage
end

Then('I should see the medication message {string}') do |text|
  expect(page).to have_content(text)
end

Then('I should see the medication {string} in the dashboard') do |medication_name|
  expect(page).to have_content(medication_name)
end

Then('I should see the dosage {string} in the medication list') do |dosage|
  expect(page).to have_content(dosage)
end

Then('I should see the end date {string} for medication {string}') do |end_date, medication_name|
  formatted_date = Date.parse(end_date).strftime('%d/%m/%Y')
  expect(page).to have_content(medication_name)
  expect(page).to have_content(formatted_date)
end

Then('I should see {string} for medication {string}') do |text, medication_name|
  expect(page).to have_content(medication_name)
  expect(page).to have_content(text)
end

Then('the medication should not appear in the dashboard') do
  expect(page).not_to have_content(@medication.name)
end

Given('I have an existing medication registered for my pet') do
  @pet = create(:pet, user: @user)
  @medication = create(:medication, pet: @pet, name: 'Vermífugo X', dosage: '5ml')
  visit user_path(@user)
end

When('I click edit on that medication') do
  find("button[data-bs-target='#medications-#{@pet.id}']").click if page.has_css?("button[data-bs-target='#medications-#{@pet.id}'][aria-expanded='false']")
  
  within("#medications-#{@pet.id}") do
    click_link '✏️', href: edit_pet_medication_path(@pet, @medication)
  end
end

When('I click delete on that medication') do
  if page.has_css?("button[data-bs-target='#medications-#{@pet.id}'][aria-expanded='false']")
    find("button[data-bs-target='#medications-#{@pet.id}']").click 
  end
  page.driver.submit :delete, pet_medication_path(@pet, @medication), {}
end