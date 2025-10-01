Given (/^I am on password reset page$/) do
  password_reset = PasswordReset.new(email: @user.email)
  password_reset.save
  @user.reload

  visit edit_password_reset_path(@user.password_reset_token)
end

When (/^I click the "(.*)" link$/) do |link|
    click_link link
end

When (/^fill the form with valid email$/) do
  fill_in "Email", :with => "teste@petmanager.com"
end

When (/^I fill the password reset form with valid passwords$/) do
  fill_in "Sua nova senha", :with => "12345"
  fill_in "Confirme sua nova senha", :with => "12345"
end

Then(/^I should see success message for email$/) do
  expect(page).to have_content("Um link para trocar sua senha foi enviado ao seu email.")
end

Then(/^I should see success message for password$/) do
  expect(page).to have_content("Sua senha foi atualizada.")
end

Then(/^I should see the login page$/) do
  expect(page).to have_content("Logue para entrar no sistema")
end
