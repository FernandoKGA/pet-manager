Feature: Login as pet owner

As a registered user
So that I can access my account
I want to be able to log in with my email and password

Background: I have an account
    Given I have an account

Scenario: Login with valid credentials
    Given I am on the login page
    When I fill the login form with login information
    And I click the Logar button
    Then I should see the initial user page

Scenario: Fill login form with invalid login information
    Given I am on the login page
    When I fill the login form with invalid login information
    And I click the Logar button
    Then I should see the failed alert
