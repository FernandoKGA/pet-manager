require 'rails_helper'

RSpec.describe "baths/show", type: :view do
  # Método auxiliar para criar um usuário válido
  def create_user(email = "teste#{rand(100)}@exemplo.com")
    User.create!(
      email: email,
      first_name: 'Bob',
      last_name:  'Burnquist',
      password:   'secret123',
    )
  end

  # Setup dos objetos de contexto
  let(:user) { create_user }

  # Método auxiliar para criar um pet válido, que precisa de um usuário
  def create_pet(user)
    Pet.create!(
      name: "Rex",
      species: 'Cachorro',
      breed:  'Vira-lata',
      user_id: user.id,
    )
  end

  # Setup dos objetos de contexto
  let(:pet) { create_pet(user) }

  it "renders attributes in <p>" do
    user = create_user
    pet = create_pet(user)
  
    # Crie o Banho com todas as associações (pet) e campos (date)
    bath_instance = Bath.create!(pet: pet, date: Time.now, price: 9.99, notes: "Banho Legal")
  
    # Atribua o @bath válido (e @pet se a view show usar @pet)
    assign(:bath, bath_instance)
    assign(:pet, pet) # Adicione caso a view show use @pet

    render
    expect(rendered).to match(//)
    expect(rendered).to match(/9.99/)
    expect(rendered).to match(/Banho Legal/)
  end
end
