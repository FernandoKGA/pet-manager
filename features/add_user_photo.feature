Feature: Add user photo

  As a user
  So that I can customize my profile
  I want to be able add or update a profile photo

Background: I am an authenticated user
    Given I am logged in
    And I have an existing profile

Scenario: Uploading and saving a profile photo for the first time
  Given I am on my profile settings
  When I upload a valid photo file
  And I save my profile
  Then I should see my new profile photo displayed

Scenario: Removing a profile photo
  Given I have an existing profile with a photo
  And I am on my profile settings
  When I remove my profile photo
  Then I should not see a profile photo displayed

