When('I open the delete modal for that pet') do
  visit user_path(@user)
  # Garante que o pet usado nos passos existe
  @pet ||= create(:pet, user: @user)

  find("button[data-bs-target='#deletePetModal-#{@pet.id}']").click
end

Then('I should not see the consultations link inside the delete modal') do
  within("#deletePetModal-#{@pet.id}", visible: false) do
    expect(page).not_to have_link("Consultas")
  end
end

Then('I should see the consultations link in the pet card actions') do
  within(".pet-card", text: @pet.name) do
    expect(page).to have_link("Consultas", href: pet_medical_appointments_path(@pet))
  end
end
