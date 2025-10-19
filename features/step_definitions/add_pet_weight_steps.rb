And("I have added a pet") do
  steps %Q{
    Given I am on the new pet page
    When I fill in the field "Nome" with "Rex"
    And I fill in the field "Espécie" with "Cachorro"
    And I fill in the field "Raça" with "Labrador"
    And I fill in the field "Data de Nascimento" with "2020-01-01"
    And I fill in the field "Tamanho" with "50"
    And I fill in the field "Gênero" with "Macho"
    And I fill in the field "ID Sinpatinhas" with "12345"
    And I press "Salvar"
    Then I should see the message "Pet cadastrado com sucesso!"
    And I should see the message "Rex"
  }
end

And("I click in the link {string}") do |link_name| 
  click_link link_name
end

Then('I should see the notice {string}') do |message|
  expect(page).to have_content(message)
end