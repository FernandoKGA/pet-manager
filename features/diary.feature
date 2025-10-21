Feature: Diary

  As a pet owner
  So that I can follow my pet day by day
  I want to be able to register a diary about my pet

  Background: I am an authenticated user
    Given I am logged in
    And I have an existing profile
    And I am on the profile page
    And I have added a pet

  Scenario: Add a new entrance at the pet diary
    When I click in the link "Diário"
    And I click in "Adicionar Entrada"
    And I fill the diary form with valid data
    And I click in "Salvar Anotação"
    Then I should see the new entry on my pet diary

  Scenario: Filter by some date at the pet diary
    Given I have added some entrances to the pet diary
    And I am at the pet diary page
    When I fill the filter by some date
    And I click in "Filtrar"
    Then I should see only entries from that date
  
  Scenario: Remove a entrance at the pet diary
    Given I have added some entrances to the pet diary
    And I am at the pet diary page
    When I remove the diary entry with content "Conteúdo 2"
    Then I should not see the entry "Conteúdo 2" anymore on my pet diary

  Scenario: Go back to the dashboard
    Given I am at the pet diary page
    When I click in the link "Voltar para o Dashboard"
    Then I am on the profile page