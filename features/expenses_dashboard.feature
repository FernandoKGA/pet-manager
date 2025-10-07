Feature: Expenses page

  As a pet owner
  So that I can control expenses with my pet
  I want to view and register new expenses

  Background:
    Given I'm logged in
    And I have a pet named "ArcticMonkeysAcoustic"
    And I have some expenses for "ArcticMonkeysAcoustic"

  Scenario: View expense chart  and filters
    When I visit the expenses page
    Then I should see a chart of my expenses
    And I should see filters for "Período" and "Pet"


  Scenario: Add expense
    When I click "Adicionar gasto"
    Then a modal should appear with the expense form
    When I fill in the form and save
    Then I should see a success message
    And the chart should update with the new expense

  Scenario: Return
    When I click "Voltar"
    Then I should be redirected to the dashboard page
