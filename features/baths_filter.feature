Feature: Filter baths
  In order to easily find bath records
  As a system user
  I want to filter baths by date and by grooming (tosa)

  Background:
    Given I am logged in with a valid username
    And a pet named "Oliver" exists
    And the following baths exist for "Oliver":
      | date                | grooming |
      | 2025-01-10 10:00:00 | Sim      |
      | 2025-01-15 15:00:00 | Não      |
      | 2025-02-01 12:00:00 | Sim      |
    And I am on the baths page for the pet "Oliver"

  Scenario: Filter by some date at the pet baths
    When I fill the baths filter by some date
    And I click in "Filtrar"
    Then I should see "1 banho"
  
  Scenario: Filter by some grooming at the pet baths
    When I fill the baths filter by some grooming
    And I click in "Filtrar"
    Then I should see "2 banhos"
