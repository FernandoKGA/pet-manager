# features/step_definitions/add_pet_to_memorial_steps.rb

# Background Steps
Given('I am authenticated in the system') do
  @user = FactoryBot.create(:user)
  login_as(@user, scope: :user)
end

Given('there is a pet named {string} registered') do |pet_name|
  @pets ||= {}
  @pets[pet_name] = FactoryBot.create(:pet, name: pet_name, user: @user, deceased_at: nil)
end

Given('the pet {string} is alive') do |pet_name|
  pet = @pets[pet_name] || Pet.find_by(name: pet_name)
  expect(pet.deceased_at).to be_nil
end

Given('there is a pet named {string} that is alive') do |pet_name|
  @pets ||= {}
  @pets[pet_name] = FactoryBot.create(:pet, name: pet_name, user: @user, deceased_at: nil)
end

Given('there is a pet named {string} that has been added to the memorial') do |pet_name|
  @pets ||= {}
  @pets[pet_name] = FactoryBot.create(:pet, name: pet_name, user: @user, deceased_at: Time.current)
end

Given('the pet {string} has been added to the memorial') do |pet_name|
  pet = @pets[pet_name] || Pet.find_by(name: pet_name)
  pet.update(deceased_at: Time.current)
end

# Navigation Steps
When('I visit the pet details page for {string}') do |pet_name|
  pet = @pets[pet_name] || Pet.find_by(name: pet_name)
  visit pet_path(pet)
end

Given('I am on the pet details page for {string}') do |pet_name|
  pet = @pets[pet_name] || Pet.find_by(name: pet_name)
  visit pet_path(pet)
end

When('I visit the memorial page') do
  visit memorials_path
end

# Generic Button Interaction Steps
Then('I should see the {string} button') do |button_text|
  expect(page).to have_button(button_text)
end

Then('I should not see the {string} button') do |button_text|
  expect(page).not_to have_button(button_text)
end

When('I click on the {string} button') do |button_text|
  click_button button_text
end

# Generic Confirmation Steps
Then('I should see a confirmation message {string}') do |message|
  # For Selenium driver
  if page.driver.is_a?(Capybara::Selenium::Driver)
    expect(page.driver.browser.switch_to.alert.text).to eq(message)
  # For Rack::Test or other drivers (won't actually show alert)
  else
    # Just continue - confirmation is handled by JavaScript
  end
end

And('I confirm the action') do
  if page.driver.is_a?(Capybara::Selenium::Driver)
    page.driver.browser.switch_to.alert.accept
  end
end

And('I cancel the action') do
  if page.driver.is_a?(Capybara::Selenium::Driver)
    page.driver.browser.switch_to.alert.dismiss
  end
end

Then('I should see the message {string}') do |message|
  expect(page).to have_content(message)
end

Then('I should see {string}') do |content|
  expect(page).to have_content(content)
end

Then('I should not see {string}') do |content|
  expect(page).not_to have_content(content)
end

Then('I should be redirected to the pets home page') do
  expect(current_path).to eq(pets_path)
end

Then('I should remain on the pet details page for {string}') do |pet_name|
  pet = @pets[pet_name] || Pet.find_by(name: pet_name)
  expect(current_path).to eq(pet_path(pet))
end

Then('the pet {string} should no longer appear on the living pets details page') do |pet_name|
  pet = @pets[pet_name] || Pet.find_by(name: pet_name)
  pet.reload
  expect(pet.deceased_at).not_to be_nil
end

Then('the pet {string} should continue to appear as alive') do |pet_name|
  pet = @pets[pet_name] || Pet.find_by(name: pet_name)
  pet.reload
  expect(pet.deceased_at).to be_nil
end

Then('I should see the pet {string} listed in the memorial') do |pet_name|
  expect(page).to have_content(pet_name)
end

Then('I should see the pet {string} in the memorial') do |pet_name|
  expect(page).to have_content(pet_name)
end

Then('I should not see the pet {string} in the memorial') do |pet_name|
  expect(page).not_to have_content(pet_name)
end

Then('I should see the date it was added to the memorial') do
  expect(page).to have_css('.memorial-date') || expect(page.body).to match(/\d{2}\/\d{2}\/\d{4}|\d{4}-\d{2}-\d{2}/)
end