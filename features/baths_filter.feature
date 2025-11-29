Feature: Filter baths
  As a logged-in user
  I want to easily find bath records
  I want to filter baths by date and by grooming

  Background: Initial Data 
    Given I am logged in with a valid username
    And I have an existing pet recorded
    And I am logged into my valid account

  Scenario: Filter by some date at the pet baths
    Given I have added some entrances to the pet bath
    And I am at the pet bath page
    When I fill the bath filter by some date
    And I run the filter by clicking the button "Filtrar Banhos"
    Then I should only see the bath entries from this data
 
  Scenario: Filter by some grooming at the pet bath
    Given I have added some entrances to the pet bath
    And I am at the pet bath page
    When I fill the filter by some grooming
    And I click in "Filtrar Banhos"
    Then I should see only entries from that grooming
