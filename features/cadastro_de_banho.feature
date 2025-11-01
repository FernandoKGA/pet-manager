Feature: Pet Bath Registration
  As a logged-in user
  I want to record my pet's baths
  So that I can keep a complete care history

  Background: Initial Data 
    Given I am logged in with a valid username
    And I have an existing pet recorded
    And I am logged into my valid account

  Scenario: Successfully register a new bath
    When I visit the baths page for "Oliver"
    And I click on "Cadastrar Novo Banho"
    And I select the current date and time for "Data e Hora"
    And I fill in "Preço" with "9,99"
    And I fill in "Observações" with "Bath and grooming at PetShop Pet Cheiroso"
    And I click the button "Salvar Banho"
    Then I should see the following message "Banho cadastrado com sucesso."
    And I should see "R$ 9,00" in the list of baths
