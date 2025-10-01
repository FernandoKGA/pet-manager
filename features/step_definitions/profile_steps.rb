Given('I am on the profile page') do
  visit user_path(@current_user)
end

When('I click the Edit button') do
  click_link 'Edit'
end

When('I fill the profile form with valid information') do
  fill_in 'First name', with: 'Ana Paula'
  fill_in 'Last name',  with: 'Souza'
  fill_in 'Email',      with: 'anapaula@example.com'
end

When('I fill the profile form with invalid information') do
  fill_in 'First name', with: ''                # inválido (presença)
  fill_in 'Email',      with: 'email-invalido'  # inválido (formato)
end

When('I click the Save button') do
  click_button 'Save'
end

Then('I should see a success message') do
  expect(page).to have_content('Profile updated successfully')
end

Then('my profile should display the updated information') do
  expect(page).to have_content('Ana Paula')
  expect(page).to have_content('Souza')
end

Then('I should see validation errors') do
  expect(page).to have_text(/(ser vazio|inválido)/i)
end


Given('I am editing my profile') do
  visit edit_user_path(@current_user)
end

When('I click the Cancel button') do
  click_link 'Cancel'
end

Then('I should see the profile page') do
  expect(page).to have_current_path(user_path(@current_user))
end

Then('the profile information should remain unchanged') do
  expect(page).to have_content(@current_user.first_name)
  expect(page).to have_content(@current_user.last_name)
end

When('I try to access the profile edit page') do
  user = User.create!(
    first_name: 'Bob', last_name: 'Owner',
    email: 'bob@example.com', password: 'secret', password_confirmation: 'secret'
  )
  visit edit_user_path(user)
end

Then('I should be redirected to the login page') do
  expect(page).to have_current_path('/login')
end

Then('my information should not be changed') do
  @current_user.reload
  expect(@current_user.attributes.slice('first_name','last_name','email'))
    .to eq(@original_profile)
end
