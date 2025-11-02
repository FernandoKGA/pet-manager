Feature: Add pet vaccination

  As a pet owner
  So that I can follow my pet's vaccinations
  I want to be able to register my pet's vaccinations

  Background: I am an authenticated user
    Given I am logged in
    And I have an existing profile
    And I am on the profile page
    And I have added a pet

  Scenario: Add a new vaccine
    When I click in the link "Vacinas"
    And I click in the link "Adicionar vacina"
    And I fill the vaccine form with valid data
    And I click in "Adicionar"
    Then I should see the new entry on my pet vaccine table

  Scenario: Edit a vaccine
    Given I have added some vaccines to my pet
    And I am at the pet vaccine page
    When I edit the vaccine with name "Rab Dose 1 Edited"
    And I click in "Atualizar"
    Then I should see the updated entry on my pet vaccine table
  
  Scenario: Remove a vaccine
    Given I have added some vaccines to my pet
    And I am at the pet vaccine page
    When I remove the vaccine with name "Rab Dose 1"
    Then I should not see the entry "Rab Dose 1" anymore on my pet vaccine table
