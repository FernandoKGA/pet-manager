Given('I am logged in as a valid user') do
  @user = User.create!(
    email: "testuser@example.com",
    password: "password123",
    first_name: "Test",
    last_name: "User"
  )

  # Usando o helper da rota
  visit login_path

  fill_in "Email", with: @user.email
  fill_in "Senha", with: "password123"
  click_button "Logar"
  expect(page).to have_content("Estamos felizes em ter você AUqui")
end

Given('I am on the new pet page') do
  visit new_pet_path
end

When('I fill in the field {string} with {string}') do |field_name, value|
  fill_in field_name, with: value
end

When("I attach the file {string} to {string}") do |file_path, field|
  attach_file(field, Rails.root.join(file_path))
end

When("I press {string}") do |button|
  click_button button
end

Then('I should see the message {string}') do |message|
  expect(page).to have_content(message)
end

Then("I should see the image {string}") do |file_name|
  expect(page).to have_css("img[src*='#{file_name}']")
end
