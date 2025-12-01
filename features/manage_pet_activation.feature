Feature: Manage pet activation

  As a pet owner
  So that I can stop seeing a pet without deleting it
  I want to deactivate and reactivate a pet

  Background:
    Given I am logged in as a valid user
    And I have an existing pet registered
    And I visit my dashboard

  Scenario: Deactivate a pet
    When I click the button "Desativar"
    Then I should not see that pet in the active pets list
    And I navigate to the inactive pets page
    Then I should see that pet in the inactive pets list

  Scenario: Reactivate a pet
    Given that pet is inactive
    When I navigate to the inactive pets page
    And I click the button "Ativar"
    Then I should see that pet in the active pets list
