Given("I am logged in as a valid user") do
  user = User.create!(
    email: "teste@teste.com",
    password: "tester",
    first_name: "teste",
    last_name: "teste"
  )

  visit login_path
  fill_in "Email", with: user.email
  fill_in "Senha", with: user.password
  click_button "Logar"
end

Given("I am on the new pet page") do
  visit new_pet_path
end

When("I fill in the field {string} with {string}") do |field, value|
  fill_in field, with: value
end

When("I press {string}") do |button|
  click_button button
end

Then("I should see the message {string}") do |text|
  expect(page).to have_content(text)
end
