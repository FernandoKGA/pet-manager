Feature: Reset password

As a registered user
So that I can log in the platform
I want to be able to reset my password

Background: I have an account
    Given I have an account

Scenario: Ask for password reset with valid email
    Given I am on the login page
    When I click the "Esqueci minha senha" link
    And fill the form with valid email
    And I click the Trocar senha button
    Then I should see success message for email
    And I should see the login page

Scenario: I received the password reset email
    Given I am on password reset page
    When I fill the password reset form with valid passwords
    And I click the Trocar senha button
    Then I should see success message for password
    And I should see the login page
