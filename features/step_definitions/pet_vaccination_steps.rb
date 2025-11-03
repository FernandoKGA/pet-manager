And('I fill the vaccine form with valid data') do
  fill_in 'Nome da vacina', with: 'Rab Dose 1'
  fill_in 'Data de vacinação', with: Date.today.to_s
  fill_in 'Responsável', with: 'CRMV-SP 123456'
  check('Aplicada')
end

Then('I should see the new entry on my pet vaccine table') do
  expect(page).to have_content('Rab Dose 1')
end

Given('I have added some vaccines to my pet') do
  @vaccination = Vaccination.create!(
    pet: @pet,
    name: 'Rab Dose 1',
    applied_date: Date.today - 2,
    applied: true,
    applied_by: 'CRMV-SP 123456'
  )
end

And('I am at the pet vaccine page') do
  visit pet_vaccinations_path(@pet)
end

And('I enter the vaccine name "Rab Dose 1"') do
  click_link "Editar"
end

When('I edit the vaccine with name "Rab Dose 1 Edited"') do
  fill_in 'Nome da vacina', with: 'Rab Dose 1 Edited'
end

Then('I should see the updated entry on my pet vaccine table') do
  expect(page).to have_content('Rab Dose 1 Edited')
end

When('I remove the vaccine with name "Rab Dose 1"') do
  click_link "Excluir"
end

Then('I should not see the entry "Rab Dose 1" anymore on my pet vaccine table') do
  expect(page).not_to have_content('Rab Dose 1')
end