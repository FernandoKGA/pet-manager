require 'rails_helper'

RSpec.describe "Baths filtering", type: :request do
  let!(:user) { FactoryBot.create(:user) }

  let!(:pet) { FactoryBot.create(:pet, user: user) }

  let!(:bath1) { FactoryBot.create(:bath, pet: pet, date: DateTime.new(2025, 1, 10, 10), tosa: true) }
  let!(:bath2) { FactoryBot.create(:bath, pet: pet, date: DateTime.new(2025, 1, 15, 15), tosa: false) }
  let!(:bath3) { FactoryBot.create(:bath, pet: pet, date: DateTime.new(2025, 2, 1, 12), tosa: true) }

  before do
    #sign_in user
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
  end

  describe "GET /pets/:pet_id/baths with filters" do
    it "retorna somente os banhos do período selecionado" do
      get pet_baths_path(pet), params: { 
        from: "2025-01-01", 
        to: "2025-01-14"
    }

      expect(response).to have_http_status(:ok)
      expect(assigns(:baths)).to match_array([bath1])
    end

    it "retorna somente os banhos com Tosa = Sim" do
      get pet_baths_path(pet), params: { tosa: "Sim" }

      expect(response).to have_http_status(:ok)
      expect(assigns(:baths)).to match_array([bath1, bath3])
    end

    it "retorna somente os banhos com Tosa = Não" do
      get pet_baths_path(pet), params: { tosa: "false" }

      expect(response).to have_http_status(:ok)
      expect(assigns(:baths)).to match_array([bath2])
    end

    it "retorna os banhos com ambos os filtros" do
      get pet_baths_path(pet), params:  { 
        from: "2025-01-01", 
        to: "2025-01-14", 
        tosa: "true"
    }

      expect(response).to have_http_status(:ok)
      expect(assigns(:baths)).to match_array([bath1])
    end

    it "retorna todos os banhos quando nenhum filtro é aplicado" do
      get pet_baths_path(pet)

      expect(assigns(:baths)).to match_array([bath1, bath2, bath3])
    end
  end
end