Feature: Cadastro de lembretes personalizados no painel

  Como um tutor de pet
  Para manter os cuidados dos meus pets em dia
  Quero criar lembretes personalizados usando a central de notificações

  Scenario: Abrir o formulário de novo lembrete pelo estado vazio da central
    Given I am logged in
    And I have a pet named "Lira"
    And I have no notifications
    When I open the notification center from the dashboard
    Then I should see the notification header actions
    And I should see the illustration "📭"
    And I should see the call to action button "Cadastrar um lembrete"

  Scenario: Abrir o formulário de novo lembrete com notificações existentes
    Given I am logged in
    And I have a pet named "Lira"
    And the following reminder notifications exist for me:
      | título                | categoria | vence_em | status | pet  |
      | Vacina V10 da Lira    | Saúde     | Amanhã   | unread | Lira |
    When I open the notification center from the dashboard
    Then I should see the notification header actions
    And I should see the notification center layout panes
    And I click the call to action button "Cadastrar um lembrete"
    Then I should see the modal heading "Novo lembrete personalizado"
    And I should see the helper text "Escolha um pet e defina como quer ser lembrado"
    And I should see the following fields in the reminder form:
      | Título do lembrete |
      | Pet |
      | Categoria |
      | Data |
      | Horário |
      | Repetição |
      | Observações |
    And I should see the primary action button "Salvar lembrete"
    And I should see the secondary action button "Cancelar"

  Scenario: Cadastrar lembrete pontual para compra de ração
    Given I am logged in
    And I have a pet named "Lira"
    And the following reminder notifications exist for me:
      | título             | categoria | vence_em | status | pet  |
      | Vacina V10 da Lira | Saúde     | Amanhã   | unread | Lira |
    When I open the notification center from the dashboard
    And I click the call to action button "Cadastrar um lembrete"
    And I fill the reminder form with:
      | Título do lembrete | Comprar ração premium |
      | Pet                | Lira                  |
      | Categoria          | Compras               |
      | Data               | Amanhã                |
      | Horário            | 09:00                 |
      | Repetição          | Não repetir           |
      | Observações        | Comprar 2 sacos de 10 kg sabor frango |
    And I click the primary action button "Salvar lembrete"
    Then I should see a toast message "Lembrete cadastrado com sucesso! 🎯"
    And I should see the notification cards in this order:
      | Comprar ração premium |
      | Vacina V10 da Lira    |
    And the notification card "Comprar ração premium" should display the badge "Nova"
    And the notification card "Comprar ração premium" should display the badge "Amanhã"

  Scenario: Cadastrar lembrete recorrente de medicação diária
    Given I am logged in
    And I have a pet named "Lira"
    And the following reminder notifications exist for me:
      | título             | categoria | vence_em | status | pet  |
      | Vacina V10 da Lira | Saúde     | Amanhã   | unread | Lira |
    When I open the notification center from the dashboard
    And I click the call to action button "Cadastrar um lembrete"
    And I fill the reminder form with:
      | Título do lembrete | Antipulgas da Lira |
      | Pet                | Lira               |
      | Categoria          | Saúde              |
      | Data               | Hoje               |
      | Horário            | 21:00              |
      | Repetição          | Diariamente        |
      | Observações        | Administrar comprimido após o jantar |
    And I click the primary action button "Salvar lembrete"
    Then I should see a toast message "Vamos te lembrar todos os dias às 21h. 💊"
    And the notification card "Antipulgas da Lira" should display the badge "Nova"
    And I should see the recurrence badge "Diariamente" on the notification card "Antipulgas da Lira"
    And the notification card "Antipulgas da Lira" should display the badge "Hoje"

  Scenario: Exibir mensagens de erro quando faltarem campos obrigatórios
    Given I am logged in
    And I have a pet named "Lira"
    And the following reminder notifications exist for me:
      | título             | categoria | vence_em | status | pet  |
      | Vacina V10 da Lira | Saúde     | Amanhã   | unread | Lira |
    When I open the notification center from the dashboard
    And I click the call to action button "Cadastrar um lembrete"
    And I submit the reminder form without filling required fields
    Then I should see the field error "Informe um título para o lembrete"
    And I should see the field error "Selecione um pet para vincular o lembrete"
    And I should see the field error "Escolha uma data válida"

  Scenario: Cancelar o cadastro sem criar um novo lembrete
    Given I am logged in
    And I have a pet named "Lira"
    And the following reminder notifications exist for me:
      | título             | categoria | vence_em | status | pet  |
      | Vacina V10 da Lira | Saúde     | Amanhã   | unread | Lira |
    When I open the notification center from the dashboard
    And I click the call to action button "Cadastrar um lembrete"
    And I click the secondary action button "Cancelar"
    Then I should not see the reminder modal
    And I should see the notification header actions
    And I should see the notification cards in this order:
      | Vacina V10 da Lira |
