Feature: Medication management
  As a pet owner
  So that I can keep track of my pet's medications
  I want to be able to add, update, and remove medication records for my pet

  Background: I am logged in
    Given I am a registered user
    And I am logged into my account
    And I have at least one pet registered

  Scenario: Add new medication record
    When I click on the medication button "Adicionar Medicamento"
    And I enter the medication name "Vermífugo X"
    And I enter the medication dosage "5ml"
    And I enter the medication frequency "Uma vez por mês"
    And I enter the medication start date "2025-10-13"
    And I enter the medication end date "2025-11-13"
    And I press the medication button "Criar Medicamento"
    Then I should see the medication message "Medicamento adicionado com sucesso"
    And I should see the medication "Vermífugo X" in the dashboard

  Scenario: Update existing medication record
    Given I have an existing medication registered for my pet
    When I click edit on that medication
    And I update the medication dosage to "10ml"
    And I press the medication button "Atualizar"
    Then I should see the medication message "Medicamento atualizado com sucesso"
    And I should see the dosage "10ml" in the medication list

  Scenario: Delete existing medication record
    Given I have an existing medication registered for my pet
    When I click delete on that medication
    Then I should see the medication message "Medicamento excluído com sucesso"
    And the medication should not appear in the dashboard
