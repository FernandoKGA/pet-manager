Given(/^I am on the features page$/) do
  visit features_path
end

Then('I should see the page title header {string}') do |header|
  expect(page).to have_content(header)
end