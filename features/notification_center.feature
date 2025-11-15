Feature: Central de notificações do tutor

  Como um tutor logado
  Para acompanhar os lembretes dos meus pets sem perder nenhum prazo
  Quero visualizar e gerenciar a central de notificações dentro do painel

  Background: estou autenticado no painel
    Given I am logged in

  Scenario: Visualizar os cards de lembretes na central com o visual do dashboard
    Given the following reminder notifications exist for me:
      | título                         | pet   | categoria        | status  | vence_em   |
      | Vacina V10 da Lira            | Lira  | Saúde            | unread  | Hoje       |
      | Consulta anual do Thor        | Thor  | Veterinário      | unread  | Em 3 dias  |
      | Banho e tosa da Mel           | Mel   | Higiene          | unread  | Em 7 dias  |
    When I open the notification center from the dashboard
    Then I should see the page heading "📬 Central de notificações"
    And I should see the subtitle "Acompanhe os lembretes dos seus pets"
    And I should see the unread counter pill with text "3 lembretes pendentes"
    And I should see the notification cards in this order:
      | Vacina V10 da Lira |
      | Consulta anual do Thor |
      | Banho e tosa da Mel |
    And the notification card "Vacina V10 da Lira" should display the badge "Hoje"
    And each notification card should show the pet name and the category pill

  Scenario: Destacar notificações não lidas com selo "Nova"
    Given I have a reminder notification titled "Vacina V10 da Lira" marked as unread
    And I have a reminder notification titled "Banho e tosa da Mel" marked as read
    When I open the notification center from the dashboard
    Then the notification card "Vacina V10 da Lira" should display the badge "Nova"
    And the notification card "Banho e tosa da Mel" should not display the badge "Nova"
    And the unread counter pill should show "1 não lida"

  Scenario: Abrir um lembrete e visualizar detalhes no painel lateral
    Given I have an unread reminder notification titled "Vacina V10 da Lira" with description "Leve a Lira para tomar a dose anual da vacina V10"
    When I open the notification center from the dashboard
    And I click the "Ver detalhes" action for the notification "Vacina V10 da Lira"
    Then I should see the side panel with title "Vacina V10 da Lira"
    And I should see the text "Leve a Lira para tomar a dose anual da vacina V10"
    And I should see the information chip "Hoje"
    And I should see the primary action button "Marcar como lida"
    And the unread counter pill should show "0 não lidas"

  Scenario: Marcar um lembrete como lido diretamente na lista
    Given I have an unread reminder notification titled "Consulta anual do Thor"
    When I open the notification center from the dashboard
    And I click the "Marcar como lida" action for the notification "Consulta anual do Thor"
    Then the notification card "Consulta anual do Thor" should appear without the badge "Nova"
    And I should see a toast message "Thor está em dia! ✅"
    And the unread counter pill should decrease by 1

  Scenario: Marcar todos os lembretes como lidos pelo atalho do topo
    Given I have multiple unread notifications
    When I open the notification center from the dashboard
    And I click the toolbar button "Marcar todas como lidas"
    Then I should see a toast message "Tudo certo! Você está em dia com os lembretes."
    And all notification cards should appear without the badge "Nova"
    And the unread counter pill should show "0 não lidas"

  Scenario: Exibir estado vazio com ilustração quando não há notificações
    Given I have no notifications
    When I open the notification center from the dashboard
    Then I should see the illustration "📭"
    And I should see the message "Você ainda não tem notificações"
    And I should see the helper text "Assim que você cadastrar lembretes, eles aparecem por aqui."
    And I should see the call to action button "Cadastrar um lembrete"

  Scenario: Bloquear acesso à central quando não estou autenticado
    Given I am not logged in
    When I try to access the notification center directly
    Then I should be redirected to the login page
    And I should see the toast "Faça login para acessar a central de notificações"
