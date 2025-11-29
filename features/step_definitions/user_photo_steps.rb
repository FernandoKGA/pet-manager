When('I navigate to my profile settings') do
  visit edit_user_path(@current_user)
end

When('I upload a valid photo file') do
  attach_file('Foto', Rails.root.join('spec/fixtures/files/bee.png'))
end

When('I save my profile') do
  click_button 'Salvar'
end

Then('I should see my new profile photo displayed') do
  expect(page).to have_css("img[src^='data:image']")
end


When('I remove my profile photo') do
  click_link 'Remover foto'
end

Then('I should not see a profile photo displayed') do
  expect(page).to have_content('Nenhuma foto enviada')

  @current_user.reload
  expect(@current_user.photo_attached?).to be(false)
end

Then('I should see a success message {string}') do |message|
  expect(page).to have_content(message)
end