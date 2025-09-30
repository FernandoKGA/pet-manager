Feature: platform registration

    As a pet owner
    So that I can use the platform
    I want to be able to register using my personal data

Background:
    Given Im in the register page
    And I fill the field "Email" with "teste@valido.com"
    And I fill the field "Nome" with "Teste"
    And I fill the field "Sobrenome" with "da Silva"
    And I fill the field "Senha" with "123456"
    And I fill the field "Confirme sua senha" with "123456"

Scenario: successfull registration
    And I click in "Registrar"
    Then I should be redirected to the login page

Scenario Outline: invalid data registration
    When I change the field "<field>" with "<value>"
    And I click in "Registrar"
    Then I should see "<message>"

Examples:
    | field              | value         | message                       |
    | Email              | email.invalid | formato de email inválido     |
    | Confirme sua senha | 323456        | As senhas não coincidem       |