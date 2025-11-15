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

Then('I should see a table with my expenses') do
  expect(page).to have_selector("table")
end

And('the table should have columns for "Data", "Descrição", "Quantidade", "Categoria" and "Pet"') do
  expect(page).to have_selector("th", text: "Data")
  expect(page).to have_selector("th", text: "Descrição")
  expect(page).to have_selector("th", text: "Quantidade")
  expect(page).to have_selector("th", text: "Categoria")
  expect(page).to have_selector("th", text: "Pet")
end