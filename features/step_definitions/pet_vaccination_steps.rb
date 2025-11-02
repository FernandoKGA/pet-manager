And('I fill the vaccine form with valid data') do
  fill_in 'Nome da vacina', with: 'Rab Dose 1'
  fill_in 'Data de vacinação', with: Date.today.to_s
  fill_in 'Responsável', with: 'CRMV-SP 123456'
  check('Aplicada')
  click_button 'Adicionar'
end

Then('I should see the new entry on my pet vaccine table') do
  expect(page).to have_content('Rab Dose 1')
end

When('I edit the vaccine with name "Rab Dose 1 Edited"') do
  fill_in 'Nome da vacina', with: 'Rab Dose 1 Edited'
end

Then('Then I should see the updated entry on my pet vaccine table') do
  expect(page).to have_content('Rab Dose 1 Edited')
end
