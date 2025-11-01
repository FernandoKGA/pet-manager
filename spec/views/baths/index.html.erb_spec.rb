require 'rails_helper'

RSpec.describe "baths/index", type: :view do
  # Método auxiliar para criar um usuário válido
  def create_user(email = "teste#{rand(100)}@exemplo.com")
    User.create!(
      email: email,
      first_name: 'Bob',
      last_name:  'Burnquist',
      password:   'secret123'
    )
  end

  # Método auxiliar para criar um pet válido
  def create_pet(user)
    Pet.create!(
      name: "Rex",
      species: 'Cachorro',
      breed:  'Vira-lata',
      user: user
    )
  end

  let(:user) { create_user }
  let(:pet)  { create_pet(user) }

  it "renders a list of baths" do
    assign(:pet, pet)

    # Cria banhos válidos com data, preço e notas
    assign(:baths, [
      Bath.create!(pet: pet, date: 1.day.ago, price: 9.99, notes: "Banho Legal"),
      Bath.create!(pet: pet, date: Time.now, price: 9.99, notes: "Banho Legal")
    ])

    render

    # Verifica se existem 2 linhas na tabela
    assert_select "table tbody tr", count: 2

    # Verifica as observações (quarta coluna)
    assert_select "table tbody tr td:nth-child(4)", text: /Banho Legal/, count: 2

    # Verifica os preços formatados (terceira coluna)
    assert_select "table tbody tr td:nth-child(3)", text: /R\$ 9,99/, count: 2

    # Verifica a data (primeira coluna) no formato dd/mm/yyyy
    assert_select "table tbody tr td:nth-child(1)", text: /\d{2}\/\d{2}\/\d{4}/, count: 2

    # Verifica se o nome do pet está presente no título
    assert_select "h1", text: /Banhos de #{pet.name}/
  end
end
