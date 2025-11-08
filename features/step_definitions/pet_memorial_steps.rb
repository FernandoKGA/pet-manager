# frozen_string_literal: true

Given('I am logged into the platform') do
  @user = FactoryBot.create(:user)
  login_as(@user, scope: :user)
end

Given('there are deceased pets registered in the system') do
  @deceased_pets = FactoryBot.create_list(:pet, 2, deceased: true, date_of_death: Date.today - 10)
end

Given('there are no deceased pets registered in the system') do
  Pet.delete_all
end

When('I visit the "Memorial" page') do
  visit memorial_path
end

When('I open the main navigation menu') do
  find('nav').click
end

When('I click on "Memorial"') do
  click_link 'Memorial'
end

Then('I should see the title "Pet Memorial"') do
  expect(page).to have_content('Pet Memorial')
end

Then('I should see a message like "In loving memory of our beloved pets"') do
  expect(page).to have_content(/In loving memory/i)
end

Then('I should see at least one pet’s name or photo displayed') do
  expect(page).to have_selector('.pet-tribute', minimum: 1)
end

Then('the date of passing should be visible') do
  expect(page).to have_content(/Date of passing|Passed away|Died on/i)
end

Then('I should see the message "No pets have passed away yet"') do
  expect(page).to have_content('No pets have passed away yet')
end

Then('I should not see any photos or tribute cards') do
  expect(page).not_to have_selector('.pet-tribute')
end

Then('I should be redirected to the "Memorial" page') do
  expect(current_path).to eq(memorial_path)
end
