#language: pt

Funcionalidade: registrar-se na plataforma

    Como um dono de pet
    Para que eu possa usar a plataforma
    Quero poder me registrar usando meus dados

Cenario: registro realizado com sucesso
    Dado que estou na tela de registro
    Quando eu insiro meu email e meu nome
    E insiro uma senha válida e a confirmo
    E clico em "Registrar"
    Então eu devo ser redirecionado para a página de login