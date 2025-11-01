Feature: Pet registration

  As a user
  So that I can manage my pets
  I want to be able to register a new pet

  Background:
    Given I am logged in as a valid user
    And I am on the new pet page

  Scenario: successful pet registration
    When I fill in the field "Nome" with "Rex"
    And I fill in the field "Espécie" with "Cachorro"
    And I fill in the field "Raça" with "Labrador"
    And I fill in the field "Data de Nascimento" with "2020-01-01"
    And I fill in the field "Tamanho" with "50"
    And I fill in the field "Gênero" with "Macho"
    And I fill in the field "ID Sinpatinhas" with "12345"
    And I attach the file "spec/fixtures/files/bee.png" to "Foto do pet"
    And I press "Registrar Pet"
    Then I should see the message "Pet cadastrado com sucesso!"
    And I should see the message "Rex"

  Scenario Outline: invalired pet registration
    When I fill in the field "<field>" with "<value>"
    And I press "Registrar Pet"
    Then I should see the message "<message>"

    Examples:
      | field    | value | message                                          |
      | Nome     |       | Não foi possível guardar as informações do pet. |
      | Espécie  |       | Não foi possível guardar as informações do pet. |
      | Raça     |       | Não foi possível guardar as informações do pet. |
