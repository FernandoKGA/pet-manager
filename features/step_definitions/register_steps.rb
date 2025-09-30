
Given('Im in the register page') do
  visit '/register'
end

When('I change the field {string} with {string}') do | field, value |
  fill_in field, :with => value
end

And('I fill the field {string} with {string}') do | field, value |
  fill_in field, :with => value
end

And('I click in {string}') do |button_name|
  click_button button_name
end

Then('I should be redirected to the login page') do
  expect(page).to have_current_path('/login')
end

Then('I should see {string}') do |message|
  expect(page).to have_selector('li', text: message)
end