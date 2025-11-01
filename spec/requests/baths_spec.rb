require 'rails_helper'

RSpec.describe "Baths", type: :request do
  # Setup dos objetos de contexto e hashes de dados

  let!(:user) { FactoryBot.create(:user) }

  let!(:pet) { FactoryBot.create(:pet, user: user) }

  let!(:bath) { FactoryBot.create(:bath, pet: pet) }

  let(:valid_bath_params) do
    { date: Time.now, price: 75.50 }
  end
  let(:invalid_bath_params) do
    { date: nil, price: 75.50 }
  end

  before do
    #sign_in user
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
  end

  describe "GET /pets/:pet_id/baths (index)" do
    it "lista os banhos do pet específico" do
      get pet_baths_path(pet)
      expect(response).to have_http_status(200)
      expect(response.body).to include(pet.name) # Verifica se o nome do pet está na página
      #expect(response.body).to include(bath.price.to_s) # Verifica se o banho está listado
      formatted_price = ActionController::Base.helpers.number_to_currency(
        bath.price,
        unit: "R$",
        separator: ",",
        delimiter: ".",
        format: "%u %n"
      )
      expect(response.body).to include(formatted_price)
    end
  end

  describe "POST /pets/:pet_id/baths (create)" do
    context "com parâmetros válidos" do
      it "cria um novo banho e redireciona" do
        expect {
          post pet_baths_path(pet), params: { bath: attributes_for(:bath, date: Time.now) }
        }.to change(Bath, :count).by(1)

        expect(response).to redirect_to(pet_baths_path(pet))
        follow_redirect!
        expect(response.body).to include('Banho cadastrado com sucesso')
      end
    end

    context "com parâmetros inválidos" do
      it "não cria o banho e exibe o formulário" do
        expect {
          post pet_baths_path(pet), params: { bath: attributes_for(:bath, date: nil) } # Data inválida
        }.not_to change(Bath, :count)

        expect(response).to have_http_status(:unprocessable_content) # ou :unprocessable_entity dependendo do controller
        
        expect(response.body).to match(/Campo data obrigatório./) # Mensagem de erro
      end
    end
  end
end
