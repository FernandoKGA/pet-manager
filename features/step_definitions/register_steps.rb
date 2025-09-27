
Dado('que estou na tela de registro') do
  visit '/register'
end

Quando('eu insiro meu email e meu nome') do
  fill_in 'Email', :with => 'teste@petmanager.com'
  fill_in 'Nome', :with => 'Teste'
  fill_in 'Sobrenome', :with => 'da Silva'
end

E('insiro uma senha válida e a confirmo') do
  fill_in 'Senha', :with => 'senha123'
  fill_in 'Confirme sua senha', :with => 'senha123'
end

E('clico em {string}') do |button_name|
  click_button button_name
end

Então('eu devo ser redirecionado para a página de login') do
  expect(page).to have_current_path('/login')
end