require 'rails_helper'

RSpec.describe "baths/new", type: :view do
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


  it "renders new bath form" do
    # 1. Crie o Pet e defina a variável @pet (necessário para a rota aninhada)
    user = create_user
    @pet = create_pet(user) 
    
    # 2. Atribua o @pet e um Bath novo ao view context
    assign(:pet, @pet)
    assign(:bath, Bath.new)

    render

    assert_select "form[action=?][method=?]", pet_baths_path(@pet), "post" do

      assert_select "input[name=?]", "bath[price]"

      assert_select "textarea[name=?]", "bath[notes]"
    end
  end
end
