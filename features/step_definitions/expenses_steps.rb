Given("I'm logged in") do
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

# Criar pet
Given('I have a pet named {string}') do |pet_name|
  user = User.last
  Pet.create!(
    name: pet_name,
    species: "Cachorro",
    breed: "Fiapo de manga",
    user: user
  )
end

# Criar despesas existentes
Given('I have some expenses for {string}') do |pet_name|
  pet = Pet.find_by!(name: pet_name)
  user = pet.user

  Expense.create!(
    amount: 150.0,
    category: "alimentacao",
    description: "Ração premium",
    date: Date.today - 2,
    pet: pet,
    user: user
  )

  Expense.create!(
    amount: 300.0,
    category: "veterinario",
    description: "Consulta de rotina",
    date: Date.today - 1,
    pet: pet,
    user: user
  )
end

# Navegação
When('I visit the expenses page') do
  visit expenses_path
end

Then('I should see a chart of my expenses') do
  expect(page).to have_css('#chart') 
end

Then('I should see filters for {string} and {string}') do |filter1, filter2|
  expect(page).to have_content(filter1)
  expect(page).to have_content(filter2)
end
