Given("a pet named {string} exists") do |name|
  @pet = create(:pet, user: @user, name: name)
end

Given("the following baths exist for {string}:") do |pet_name, table|
  pet = Pet.find_by(name: pet_name)

  table.hashes.each do |row|
    tosa_value = row["grooming"].downcase == "sim"

    create(:bath,
           pet: pet,
           date: DateTime.parse(row["date"]),
           tosa: tosa_value)
  end
end

Given("I am on the baths page for the pet {string}") do |pet_name|
  pet = Pet.find_by(name: pet_name)
  visit pet_baths_path(pet)
end

#When("I fill the baths filter by some date") do
#  fill_in "Data inicial:", with: "2025-01-10"
#  fill_in "Data final:",   with: "2025-01-10"
#end

#When("I fill the baths filter by some grooming") do
#  fill_in "Tosa:", with: "Sim"
#end

