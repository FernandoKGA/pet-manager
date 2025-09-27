Given(/^I have an account$/) do
  user = User.new(email: "teste@petmanager.com", first_name: "Teste", last_name: "Da Silva", password: "teste001user")
  user.save
  @user = user
end

Given (/^I am on the login page$/) do
  visit "login"
end

When (/^I fill the login form with login information$/) do
  fill_in "Email", :with => "teste@petmanager.com"
  fill_in "Senha", :with => "teste001user"
end

When (/^I click the (.*) button$/) do |button_name|
    click_button button_name
end

Then (/^I should see the initial user page$/) do
  expect(page).to have_content("Você está logado!")
end

When(/^I fill the login form with invalid login information$/) do
  fill_in "Email", :with => "emailinvalido@email.com"
  fill_in "Senha", :with => "senha errada"
end

Then("I should see the failed alert") do
  expect(page).to have_content("Algo deu errado! Por favor, verifique suas credenciais.")
end
