Given('I am logged in') do
  @current_user = User.create!(
    first_name: 'Ana', last_name: 'Silva',
    email: 'ana@example.com', password: 'secret', password_confirmation: 'secret'
  )

  visit '/login'

  # Use os IDs gerados por form_for :session
  fill_in 'session_email', with: @current_user.email
  fill_in 'session_password', with: 'secret'

  click_button 'Logar'

  # Snapshot para checar “not changed”
  @original_profile = @current_user.attributes.slice('first_name','last_name','email')
end

Given('I have an existing profile') do
  expect(@current_user).to be_present
end

Given('I am not logged in') do
  Capybara.reset_sessions!
end
