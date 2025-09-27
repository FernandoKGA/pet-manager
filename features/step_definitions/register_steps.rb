
Dado('que estou na tela de registro') do
  visit '/register'
end

Quando('eu insiro meu email e meu nome') do
  fill_in 'Email', :with => 'teste@petmanager.com'
  fill_in 'Nome', :with => 'Teste'
  fill_in 'Sobrenome', :with => 'da Silva'
end

Quando('eu altero o campo {string} com {string}') do | field, value |
  fill_in field, :with => value
end

E('preencho o campo {string} com {string}') do | field, value |
  fill_in field, :with => value
end

E('clico em {string}') do |button_name|
  click_button button_name
end

Então('eu devo ser redirecionado para a página de login') do
  expect(page).to have_current_path('/login')
end

Então('eu devo ver a mensagem {string}') do |message|
  expect(page).to have_selector('li', text: message)
end