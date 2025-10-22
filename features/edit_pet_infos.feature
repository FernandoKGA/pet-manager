Feature: Pet management
  As a pet owner
  So that I can add, update or remove information about my pet
  I want to be able to manage my pet's information on the platform

  Background: I am logged in
    Given I am a registered user
    And I am logged into my account

  Scenario: Add new pet information
    When I navigate to the "Add Pet" page
    And I fill in the pet form with valid information
    And I press "Registrar Pet"
    Then I should see the new pet listed in my pets page

  Scenario: Update existing pet information
    Given I have an existing pet registered
    When I navigate to the "Edit Pet" page for that pet
    And I update the pet information with valid data
    And I press "Atualizar Pet"
    Then I should see the updated information in my pets page