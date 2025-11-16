Given('I am logged in with a valid username') do
  @user = User.create!(
    email: "teste@teste.com",
    password: "tester",
    first_name: "Marcio",
    last_name: "Silva"
  )
end

And('I am logged into my valid account') do
  visit login_path
  fill_in 'Email', with: @user.email
  fill_in 'Senha', with: 'tester'
  click_button 'Logar'
end

Given('I have an existing pet recorded') do
  @pet = Pet.create!(
    name: 'Oliver',
    species: 'Cachorro',
    breed: 'Lhasa Apso',
    birthdate: '2002-06-15',
    size: 20,
    gender: 'Macho',
    sinpatinhas_id: '1207',
    user: @user
  )
end

When('I visit the baths page for {string}') do |_pet_name|
  visit pet_baths_path(@pet)
end

Given("I am on the new_pet_bath_path") do
  visit new_pet_bath_path(@pet)
end

When('I click on {string}') do |button_text|
 click_on button_text
end

When('I select the current date and time for {string}') do |field_label|
  within("form") do
    fill_in field_label, with: Time.now.strftime("%Y-%m-%d %H:%M")
  end
end

When('I fill in {string} with {string}') do |field_label, value|
  fill_in field_label, with: value
end

Then("I should see the following message {string}") do |text|
  expect(page).to have_content(text)
end

Then('I should see {string} in the list of baths') do |price|
  within('table') do
    expect(page).to have_content(price)
  end
end

Then('I should be on the new bath registration page') do
  expect(current_path).to eq(new_pet_bath_path(@pet))
end
