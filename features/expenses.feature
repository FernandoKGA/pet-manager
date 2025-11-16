Feature: Expenses page

  As a pet owner
  So that I can control expenses with my pet
  I want to view and register new expenses

  Background:
    Given I am logged in as a valid user
    And I have a pet named "ArcticMonkeysAcoustic"
    And I have some expenses for "ArcticMonkeysAcoustic"

  Scenario: View expense chart and filters
    When I visit the expenses page
    Then I should see a chart of my expenses
    And I should see filters for "Período" and "Pet"

  Scenario: View expenses table 
    When I visit the expenses page
    Then I should see a table with my expenses
    And the table should have columns for "Data", "Descrição", "Quantidade", "Categoria" and "Pet"