require 'rails_helper'

RSpec.describe "baths/edit", type: :view do
  let(:user) do
    User.create!(
      email: "teste#{rand(100)}@exemplo.com",
      first_name: 'Bob',
      last_name: 'Burnquist',
      password: 'secret123'
    )
  end

  let(:pet) do
    Pet.create!(
      name: "Rex",
      species: 'Cachorro',
      breed: 'Vira-lata',
      user: user
    )
  end

  let(:bath) do
    Bath.create!(
      pet: pet,
      date: Time.now,
      price: 49.99,
      notes: "Banho Legal"
    )
  end

  before do
    # Assigns que a view precisa
    assign(:pet, pet)
    assign(:bath, bath)
  end

  it "renders the edit bath form" do
    render

    # Verifica se o formulário está presente
    assert_select "form[action=?][method=?]", pet_bath_path(pet, bath), "post" do
      assert_select "input[name=?]", "bath[price]"
      assert_select "textarea[name=?]", "bath[notes]"
      assert_select "input[name=?]", "bath[date]"
    end

    # Verifica se o link de voltar está presente
    assert_select "a.btn-secondary-custom[href=?]", pet_baths_path(pet)
  end
end
