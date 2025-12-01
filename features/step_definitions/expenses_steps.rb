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

When('I edit the expense {string} changing description to {string} and amount to {string}') do |current_description, new_description, new_amount|
  within("tr", text: current_description) do
    click_link "Editar"
  end
  expect(page).to have_css('#expense-modal', visible: true)

  fill_in "expense_description", with: new_description
  fill_in "expense_amount", with: new_amount
  click_button "Salvar"
end

When('I delete the expense {string}') do |description|
  within("tr", text: description) do
    begin
      accept_confirm do
        click_button "Excluir"
      end
    rescue Capybara::NotSupportedByDriverError, Capybara::ModalNotFound
      click_button "Excluir"
    end
  end
end

Then('I should see {string} in the expenses table') do |content|
  within("table") do
    expect(page).to have_content(content)
  end
end

Then('I should not see {string}') do |content|
  expect(page).not_to have_content(content)
end