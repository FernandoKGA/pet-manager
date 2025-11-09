Feature: Add Pet to Memorial
  As a system user
  I want to add my pet to the memorial
  So that I can honor them after their passing

  Background:
    Given I am authenticated in the system
    And there is a pet named "Rex" registered
    And the pet "Rex" is alive

  Scenario: View add to memorial button on pet page
    When I visit the pet details page for "Rex"
    Then I should see the "Add to Memorial" button

  Scenario: Successfully add pet to memorial
    Given I am on the pet details page for "Rex"
    When I click on the "Add to Memorial" button
    Then I should see a confirmation message "Are you sure you want to add Rex to the memorial?"
    And I confirm the action
    Then I should see the message "Rex has been successfully added to the memorial"
    And I should be redirected to the pets home page
    And the pet "Rex" should no longer appear on the living pets details page

  Scenario: Cancel adding pet to memorial
    Given I am on the pet details page for "Rex"
    When I click on the "Add to Memorial" button
    Then I should see a confirmation message "Are you sure you want to add Rex to the memorial?"
    And I cancel the action
    Then I should remain on the pet details page for "Rex"
    And the pet "Rex" should continue to appear as alive

  Scenario: View pet in memorial index
    Given the pet "Rex" has been added to the memorial
    When I visit the memorial page
    Then I should see the pet "Rex" listed in the memorial
    And I should see the date it was added to the memorial

  Scenario: Pet in memorial should not have add to memorial button
    Given the pet "Rex" has been added to the memorial
    When I visit the pet details page for "Rex" in the memorial
    Then I should not see the "Add to Memorial" button

  Scenario: Living pets do not appear in memorial
    Given there is a pet named "Bolinha" that is alive
    And there is a pet named "Miau" that has been added to the memorial
    When I visit the memorial page
    Then I should see the pet "Miau" in the memorial
    And I should not see the pet "Bolinha" in the memorial