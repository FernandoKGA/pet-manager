Given("I have added some entrances to the pet bath") do
    pet = Pet.create!(
    name: 'Oliver 2',
    species: 'Cachorro',
    breed: 'Lhasa Apso',
    birthdate: '2002-06-15',
    size: 20,
    gender: 'Macho',
    sinpatinhas_id: '1207',
    user: @user
  )

  bt1 = Bath.new(pet: pet,
        date: "2025-08-30T14:30",
        price: 90,
        tosa: "Sim",
        notes: "Táxi dog"
  )
  bt1.save

  bt2 = Bath.new(pet: pet,
        date: "2025-09-30T14:30",
        price: 90,
        tosa: "Não",
        notes: "Vou levar"
  )
  bt2.save
end

And("I am at the pet bath page") do
  visit pet_baths_path(@pet)
end

When("I fill the bath filter by some date") do
  fill_in "Data inicial", with: "2025-09-30"
  fill_in "Data final", with: "2025-09-30"
end

And('I run the filter by clicking the button {string}') do |button_name|
 click_button button_name
end

Then("I should only see the bath entries from this data") do
  expect(page).to have_content('Sim')
end

When("I fill the filter by some grooming") do
  select "Sim", from: "Tosa"
end

