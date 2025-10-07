Feature: Register pet expense

  As a pet owner
  So that I can control expenses with my pet
  I want to register a new expense for one of my pets

  Background:
    Given I'm logged in as a user
    And I have a pet named "ArcticMonkeysAcoustic"

  Scenario: Successfully register a new expense
    Given I am on the "New Expense" page
    When I fill in "Amount" with "999.9"
    And I fill in "Category" with "Saúde"
    And I select "ArcticMonkeysAcoustic" from "Pet"
    And I click "Salvar"
    Then I should see "Gasto registrado com sucesso"
    And I should see "ArcticMonkeysAcoustic"
    And I should see "Saúde"

