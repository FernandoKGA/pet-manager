Feature: About page

  Scenario: Visitor access about page
    Given I am on the about page
    Then I should see the application logo
    And I should see the mission statement header