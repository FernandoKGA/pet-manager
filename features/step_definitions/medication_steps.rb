Given('I am a registered user') do
  @user = create(:user, email: 'test@example.com', password: 'password123')
end

Given('I am logged into my account') do
  visit new_user_session_path
  fill_in 'email', with: @user.email
  fill_in 'password', with: @user.password
  click_button 'Entrar'
end

Given('I have at least one pet registered') do
  @pet = create(:pet, user: @user)
  visit dashboard_path
end

When('I click the {string} button') do |button_text|
  click_button button_text
end

When('I press {string}') do |button_text|
  click_button button_text
end

When('I enter the name {string}') do |name|
  fill_in 'Nome do Medicamento', with: name
end

When('I enter the dosage {string}') do |dosage|
  fill_in 'Dosagem', with: dosage
end

When('I enter the frequency {string}') do |frequency|
  fill_in 'Frequência', with: frequency
end

When('I enter the start date {string}') do |date|
  fill_in 'Data de Início', with: date
end

Then('I should see {string}') do |text|
  expect(page).to have_content(text)
end

Then('I should see the medication {string} in the dashboard') do |medication_name|
  expect(page).to have_content(medication_name)
end

Given('I have an existing medication registered for my pet') do
  @pet = create(:pet, user: @user)
  @medication = create(:medication, pet: @pet, name: 'Vermífugo X', dosage: '5ml')
  visit pet_medications_path(@pet)
end

When('I click edit on that medication') do
  find("a[href='#{edit_pet_medication_path(@pet, @medication)}']").click
end

When('I update the dosage to {string}') do |dosage|
  fill_in 'Dosagem', with: dosage
end

Then('I should see the dosage {string} in the medication list') do |dosage|
  expect(page).to have_content(dosage)
end

When('I click delete on that medication') do
  find("a[href='#{pet_medication_path(@pet, @medication)}'][data-method='delete']").click
end

When('I confirm the deletion') do
  page.accept_confirm
end

Then('the medication should not appear in the dashboard') do
  expect(page).not_to have_content('Vermífugo X')
end

# ==================== PET STEPS ====================
When('I fill in pet information with:') do |table|
  table.hashes.each do |row|
    fill_in 'Nome do Pet', with: row['name'] if row['name']
    fill_in 'Idade', with: row['age'] if row['age']
    fill_in 'Raça', with: row['breed'] if row['breed']
    select row['species'], from: 'Espécie' if row['species']
  end
end

When('I click the add pet button') do
  click_button 'Adicionar Pet'
end

Then('I should see the pet {string} listed') do |pet_name|
  expect(page).to have_content(pet_name)
end

Then('the pet should not be created') do
  expect(page).to have_content('Erro')
end