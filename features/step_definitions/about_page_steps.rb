Given(/^I am on the about page$/) do
  visit about_path
end

Then(/^I should see the application logo$/) do 
  expect(page).to have_css('img[alt="Pet Manager Logo"]')
end

Then(/^I should see the mission statement header$/) do 
  expect(page).to have_content("Nossa Missão")
end