require 'rails_helper'

RSpec.describe "Pets", type: :request do
  let(:user) do
    User.create!(
      email: "test@teste.com",
      password: "tester",
      first_name: "teste",
      last_name: "teste"
    )
  end

  before do
    # Aqui estamos dizendo que toda vez que current_user for chamado,
    # ele vai retornar o user de teste.
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
  end

  describe "GET /pets/new" do
    it "returns http success" do
      get new_pet_path
      expect(response).to have_http_status(:ok)
    end
  end
end
