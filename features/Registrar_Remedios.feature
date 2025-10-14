Feature: Medication management
  As a pet owner
  So that I can keep track of my pet's medications
  I want to be able to add, update, and remove medication records for my pet

  Background: I am logged in
    Given I am a registered user
    And I am logged into my account
    And I have at least one pet registered

Scenario: Add new medication record
  When I navigate to the "Add Medication" page
  And I fill in the medication form with valid information
  And I enter the name "Vermífugo X"
  And I enter the dosage "5ml"
  And I enter the frequency "Once a month"
  And I enter the start date "2025-10-13"
  And I press "Salvar"
  Then I should see the new medication listed in my pet's medication page

Scenario: Update existing medication record
  Given I have an existing medication registered for my pet
  When I navigate to the "Edit Medication" page for that record
  And I update the dosage to "10ml"
  And I press "Atualizar"
  Then I should see the updated information in my pet's medication list

Scenario: Remove a medication record
  Given I have an existing medication registered for my pet
  When I press "Excluir" on that medication record
  And I confirm the deletion
  Then the medication record should no longer appear in my pet's medication list
