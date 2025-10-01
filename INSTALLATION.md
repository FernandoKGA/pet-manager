# Instalação

## Sumário

- [Instalação](#instalação)
  - [Sumário](#sumário)
  - [Linux e Docker](#linux-e-docker)
  - [Programas](#programas)
    - [Essenciais](#essenciais)
    - [Git](#git)
    - [Gerenciador de versões do Ruby](#gerenciador-de-versões-do-ruby)
    - [Versão específica do Ruby](#versão-específica-do-ruby)
    - [Bundler Gem](#bundler-gem)
    - [PostgreSQL](#postgresql)
  - [Executando](#executando)
  - [Testes](#testes)
  - [Links úteis](#links-úteis)

Para que seja possível rodar o projeto, serão necessárias algumas instalações. Se você possuir um Linux ou MacOS será mais fácil executar as instruções, caso você tenha Windows, sugerimos criar uma máquina WSL2 com Linux na distribuição de sua preferência.

## Linux e Docker

Caso você esteja no Windows, siga essas instruções para instalar o Linux via WSL: https://learn.microsoft.com/en-us/windows/wsl/install.

Se você já tiver Linux ou MacOS, siga as instruções para instalar o serviço do Docker, que será necessário para executar algumas operações.

## Programas

Rodar o projeto exige instalação de programas adicionais que não estão presentes por padrão na distribuição. Para agilizar um pouco o procedimento, abra o terminal dentro do Linux, para rodar os comandos, use `sudo` para ter voz de administrador. Execute então `sudo apt-get update` e aguarde ele terminar de buscar os dados. Após essa execução, rode `sudo apt-get upgrade` para atualizar os pacotes e serviços existentes do Linux para as mais novas versões.

### Essenciais

`sudo apt-get install libvips pkg-config`

### Git

Git é um programa de versionamento de código amplamente utilizado pelo mundo do desenvolvimento.

`sudo apt-get install git`

Para configurar o Git, use:
```bash
git config --global color.ui true
git config --global user.name "USERNAME QUE CADASTROU NO GITHUB"
git config --global user.email "EMAIL QUE CADASTROU NO GITHUB"
git config --global user.password "SENHA QUE CADASTROU NO GITHUB"
```

Depois de feita a configuração, você pode **baixar este repositório** no seu computador se o ainda não fez.

### Gerenciador de versões do Ruby

Para termos um ambiente padrão, vamos criar um `rbenv` que será o gerenciador de versões do Ruby e do seu framework, o Rails.

```bash
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
~/.rbenv/bin/rbenv init
rbenv version
```

### Versão específica do Ruby

Para podermos rodar o projeto, devemos possuir a linguagem de programação Ruby e seu ambiente, dado isso vamos baixá-la através do nosso gerenciador de versões na versão 3.4.6.

```bash
rbenv install 3.4.6
rbenv global 3.4.6
ruby -v
```

### Bundler Gem

O Bundler Gem é o gerenciador de "gemas" do Ruby, ele controla os pacotes, que são as gemas, que serão instaladas ao ambiente.

```bash
gem install bundler
```

Antes de executarmos o nosso projeto, precisamos construir as nossas bibliotecas do projeto para que ele execute e instale as adicionais faltantes. Para fazermos isso, rode o seguinte comando:

```bash
bundle install
```

### PostgreSQL

Para um serviço de banco de dados PostgreSQL, você pode tanto baixar o programa diretamente do site deles, quanto usar uma imagem Docker (recomendado). Site do PostgreSQL para baixar para Ubuntu, baixe a versão `17.4`: https://www.postgresql.org/download/linux/ubuntu/

Versão em Docker, baixe a imagem primeiro:

```bash
docker pull postgres:17.4
```

Depois, levante o container Docker da imagem que irá rodar em background:

```bash
docker run --name rails-postgres -e POSTGRES_PASSWORD=postgresql -e POSTGRESQL_USER=postgres -e POSTGRES_DB=myapp_development -p 5432:5432 -d postgres:17.4
```

Após iniciar a imagem Docker, você deveria rodar para criar o banco de dados ou rodar migrações para serem executadas.

```bash
rails db:prepare
```

Caso você reinicie o sistema, você terá de reiniciar assim que for utilizar o projeto, para que não ocorram problemas na hora de subir e estabelecer a comunicação.

```bash
docker start rails-postgres
```

## Executando

Execute o projeto Rails através do Terminal.

```bash
rails s 
```

Abra seu browser e vá para o endereço <http://localhost:3000>, seu projeto estará lá.

## Testes

Para rodar os testes unitário e de integração, rode:

```bash
rake spec
```

Para os testes de aceitação, rode:
```bash
rake cucumber
```

## Links úteis

- https://learn.microsoft.com/en-us/windows/wsl/install
- https://github.com/rbenv/rbenv?tab=readme-ov-file
- https://www.devmedia.com.br/ruby-on-rails-tutorial/31285
- https://guides.rubyonrails.org/v7.1/testing.html
- https://cucumber.io/docs/
