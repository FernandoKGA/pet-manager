#language: pt

Funcionalidade: registrar-se na plataforma

    Como um dono de pet
    Para que eu possa usar a plataforma
    Quero poder me registrar usando meus dados

Contexto:
    Dado que estou na tela de registro
    E preencho o campo "Email" com "teste@valido.com"
    E preencho o campo "Nome" com "Teste"
    E preencho o campo "Sobrenome" com "da Silva"
    E preencho o campo "Senha" com "123456"
    E preencho o campo "Confirme sua senha" com "123456"

Cenario: registro realizado com sucesso
    E clico em "Registrar"
    Então eu devo ser redirecionado para a página de login

Esquema do Cenário: registro com dados inválidos
    Quando eu altero o campo "<field>" com "<value>"
    E clico em "Registrar"
    Então eu devo ver a mensagem "<message>"

Exemplos:
    | field              | value         | message                       |
    | Email              | email.invalid | formato de email inválido     |
    | Confirme sua senha | 323456        | As senhas não coincidem       |