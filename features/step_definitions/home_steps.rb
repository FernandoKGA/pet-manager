Given("eu estou na página inicial") do
  visit root_path
end

Then ("eu devo ver o logotipo da aplicação") do 
  expect(page).to have_css('img[alt="Pet Manager Logo"]')
end

Then('eu devo ver a mensagem de boas-vindas {string}') do |mensagem|
  expect(page).to have_content(mensagem)
end