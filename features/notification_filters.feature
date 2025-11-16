Feature: Filtro de notificações na central

  Como um tutor de pet
  Para encontrar rapidamente os lembretes mais relevantes
  Quero filtrar as notificações por status, categoria e período

  Background: tutor autenticado no painel
    Given I am logged in

  Scenario: Exibir controles de filtro de status, categoria e período
    Given the following reminder notifications exist for me:
      | título              | pet  | categoria | status | vence_em  |
      | Vacina V10 da Lira  | Lira | Saúde     | unread | Hoje       |
      | Banho e tosa da Mel | Mel  | Higiene   | read   | Em 3 dias  |
    When I open the notification center from the dashboard
    Then I should see the filter controls for status, category and period

  Scenario: Filtrar notificações não lidas pelo status
    Given the following reminder notifications exist for me:
      | título                    | pet  | categoria    | status | vence_em  |
      | Vacina V10 da Lira        | Lira | Saúde        | unread | Hoje      |
      | Consulta anual do Thor    | Thor | Veterinário  | unread | Em 3 dias |
      | Banho e tosa da Mel       | Mel  | Higiene      | read   | Em 5 dias  |
      | Ração especial da Mia     | Mia  | Compras      | read   | Em 10 dias |
    When I open the notification center from the dashboard
    And I apply the status filter "Não lidas"
    Then I should see the notification cards in this order:
      | Vacina V10 da Lira     |
      | Consulta anual do Thor |
    And I should see the active filter tag "Status: Não lidas"

  Scenario: Filtrar notificações por categoria do lembrete
    Given the following reminder notifications exist for me:
      | título                     | pet  | categoria   | status | vence_em  |
      | Vacina V10 da Lira         | Lira | Saúde       | unread | Hoje       |
      | Antipulgas diária da Lira  | Lira | Saúde       | unread | Em 2 dias  |
      | Banho e tosa da Mel        | Mel  | Higiene     | read   | Em 7 dias  |
      | Reposição de ração do Thor | Thor | Compras     | unread | Em 14 dias |
    When I open the notification center from the dashboard
    And I apply the category filter "Saúde"
    Then I should see the notification cards in this order:
      | Vacina V10 da Lira        |
      | Antipulgas diária da Lira |
    And each notification card should show the pet name and the category pill
    And I should see the active filter tag "Categoria: Saúde"

  Scenario: Filtrar notificações por período de vencimento
    Given the following reminder notifications exist for me:
      | título                     | pet  | categoria   | status | vence_em  |
      | Consulta de retorno do Thor| Thor | Veterinário | unread | Ontem      |
      | Vacina V10 da Lira         | Lira | Saúde       | unread | Hoje       |
      | Ração especial da Mia      | Mia  | Compras     | read   | Em 10 dias |
      | Check-up anual da Mel      | Mel  | Veterinário | unread | Em 40 dias |
    When I open the notification center from the dashboard
    And I filter notifications from "Hoje" to "Em 15 dias"
    Then I should see the notification cards in this order:
      | Vacina V10 da Lira    |
      | Ração especial da Mia |
    And I should see the active filter tag "Período: Hoje até Em 15 dias"

  Scenario: Combinar filtros de status, categoria e período
    Given the following reminder notifications exist for me:
      | título                     | pet  | categoria   | status | vence_em  |
      | Vacina V10 da Lira         | Lira | Saúde       | unread | Hoje      |
      | Banho e tosa da Mel        | Mel  | Higiene     | unread | Em 5 dias |
      | Reposição de ração do Thor | Thor | Compras     | unread | Em 8 dias |
      | Consulta anual do Thor     | Thor | Veterinário | read   | Em 7 dias |
    When I open the notification center from the dashboard
    And I apply the status filter "Não lidas"
    And I apply the category filter "Saúde"
    And I filter notifications from "Hoje" to "Em 7 dias"
    Then I should see the notification cards in this order:
      | Vacina V10 da Lira |
    And I should see the active filter summary "Status: Não lidas • Categoria: Saúde • Período: Hoje até Em 7 dias"
