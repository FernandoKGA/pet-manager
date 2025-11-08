Feature: Pet memorial page
  As a user
  I want to view the memorial page
  So that I can remember pets who have passed away, or know that none have yet

  Background:
    Given I am logged into the platform

  Scenario: Visit the memorial page with deceased pets
    Given there are deceased pets registered in the system
    When I visit the "Memorial" page
    Then I should see the title "Pet Memorial"
    And I should see a message like "In loving memory of our beloved pets"
    And I should see at least one pet's name or photo displayed
    And the date of passing should be visible

  Scenario: Visit the memorial page with no deceased pets
    Given there are no deceased pets registered in the system
    When I visit the "Memorial" page
    Then I should see the title "Pet Memorial"
    And I should see the empty memorial message
    And I should not see any photos or tribute cards

  Scenario: Access the memorial page from the user profile page
    When I visit the user profile page
    And I click on the Memorial link
    Then I should be redirected to the "Memorial" page
    And I should see the title "Pet Memorial"