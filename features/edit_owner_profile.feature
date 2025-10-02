Feature: Edit owner profile data

As a registered user
So that I can keep my information up to date
I want to be able to edit my registration details

Background: I am an authenticated user
    Given I am logged in
    And I have an existing profile

Scenario: Update profile with valid data
    Given I am on the profile page
    When I click the Edit button
    And I fill the profile form with valid information
    And I click the Salvar button
    Then I should see a success message
    And my profile should display the updated information

Scenario: Try to save with invalid data
    Given I am on the profile page
    When I click the Edit button
    And I fill the profile form with invalid information
    And I click the Salvar button
    Then I should see validation errors
    And my information should not be changed

Scenario: Cancel editing
    Given I am editing my profile
    When I click the Cancel button
    Then I should see the profile page
    And the profile information should remain unchanged

Scenario: Block editing when not authenticated
    Given I am not logged in
    When I try to access the profile edit page
    Then I should be redirected to the login page
