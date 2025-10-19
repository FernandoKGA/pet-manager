Feature: Add pet weight

  As a user
  So that I can follow my pet's weight changes
  I want to be able to register my pet's current weight

  Background:
    Given I am logged in as a valid user
    And I have added a pet

  Scenario: add a valid weight
    When I click in the link "Atualizar peso"
    And I fill the field "Peso atual" with "30"
    And I click in "Atualizar peso"
    Then I should see the notice "Peso atualizado com sucesso"