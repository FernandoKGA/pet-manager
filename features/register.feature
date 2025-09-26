#language: pt

Funcionalidade: registrar-se na plataforma

    Como um dono de pet
    Para que eu possa usar a plataforma
    Quero poder me registrar usando meus dados

Cenario: registro realizado com sucesso
    Dado que estou na tela de registro
    Quando eu insiro meu email
    E meu nome
    E uma senha
    E clico em registrar
    Então eu devo ver uma mensagem informando que fui registrado com sucesso