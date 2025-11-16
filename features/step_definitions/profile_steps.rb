Given('I am on the profile page') do
  visit user_path(@current_user)
end

When('I fill the profile form with valid information') do
  fill_in 'Primeiro Nome', with: 'Ana Paula'
  fill_in 'Sobrenome',  with: 'Souza'
  fill_in 'Email',      with: 'anapaula@example.com'
end

When('I fill the profile form with invalid information') do
  fill_in 'Primeiro Nome', with: ''                # inválido (presença)
  fill_in 'Email',      with: 'email-invalido'  # inválido (formato)
end

Then('I should see a success message') do
  expect(page).to have_content('Profile updated successfully')
end

Then('my profile should display the updated information') do
  expect(page).to have_content('Ana Paula')
  expect(page).to have_content('Souza')
end

Then('I should see validation errors') do
  expect(page).to have_text(/(ser vazio|inválido|invalid|blank)/i)
end


Given('I am editing my profile') do
  visit edit_user_path(@current_user)
end

When('I click the Cancelar link') do
  click_link 'Cancelar'
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

Then('my information should not be changed') do
  @current_user.reload
  expect(@current_user.attributes.slice('first_name','last_name','email'))
    .to eq(@original_profile)
end
