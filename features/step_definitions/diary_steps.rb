And("I fill the diary form with valid data") do
  fill_in "Data e Hora", :with => "2025-10-19T14:30"
  fill_in "Anotação", :with => "Algum conteúdo para preencher aqui de teste"
end

Then("I should see the new entry on my pet diary") do
  expect(page).to have_content('Algum conteúdo para preencher aqui de teste')
end

Given("I have added some entrances to the pet diary") do
  pet = @current_user.pets.last
  de1 = DiaryEntry.new(
    pet: pet,
    entry_date: "2025-10-18T14:30",
    content: "Conteúdo 1",
  )
  de1.save

  de2 = DiaryEntry.new(
    pet: pet,
    entry_date: "2025-10-19T14:30",
    content: "Conteúdo 2",
  )
  de2.save
end

And("I am at the pet diary page") do
  visit pet_diary_entries_path(@current_user.pets.last)
end

When("I fill the filter by some date") do
  fill_in "Filtrar por dia:", with: "2025-10-19"
end

Then("I should see only entries from that date") do
  expect(page).to have_content('Conteúdo 2')
end

When("I remove the diary entry with content {string}") do |content|
  entry_card = find('.diary-entry-card', text: content)

  within(entry_card) do
    click_button 'Remover'
  end
end

Then("I should not see the entry {string} anymore on my pet diary") do |content|
  expect(page).not_to have_content(content)
end