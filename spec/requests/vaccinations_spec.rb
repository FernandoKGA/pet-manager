require 'rails_helper'

RSpec.describe "Vaccinations", type: :request do
  let(:owner) { create(:user) }
  let(:pet) { create(:pet, user: owner) }
  let(:current_user) { owner }

  before do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(current_user)
  end

  describe "GET /pets/:pet_id/vaccinations" do
    it "retorna sucesso" do
      create(:vaccination, pet: pet)

      get pet_vaccinations_path(pet)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Vacinas de")
    end
  end

  describe "POST /pets/:pet_id/vaccinations" do
    it "cria uma nova vacina" do
      expect do
        post pet_vaccinations_path(pet), params: {
          vaccination: {
            vaccine_name: "Antirrábica",
            administered_on: Date.current,
            next_due_on: Date.current.next_year
          }
        }
      end.to change { pet.vaccinations.count }.by(1)

      expect(response).to redirect_to(pet_vaccinations_path(pet))
      follow_redirect!
      expect(response.body).to include("Vacina registrada com sucesso")
    end

    it "não cria com dados inválidos" do
      expect do
        post pet_vaccinations_path(pet), params: { vaccination: { vaccine_name: "" } }
      end.not_to change { pet.vaccinations.count }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to include("Vacina")
    end
  end

  describe "PATCH /pets/:pet_id/vaccinations/:id" do
    let(:vaccination) { create(:vaccination, pet: pet) }

    it "atualiza o registro" do
      patch pet_vaccination_path(pet, vaccination), params: {
        vaccination: { notes: "Reação leve" }
      }

      expect(response).to redirect_to(pet_vaccinations_path(pet))
      follow_redirect!
      expect(response.body).to include("Vacina atualizada com sucesso")
      expect(vaccination.reload.notes).to eq("Reação leve")
    end
  end

  describe "DELETE /pets/:pet_id/vaccinations/:id" do
    it "remove o registro" do
      vaccination = create(:vaccination, pet: pet)

      expect do
        delete pet_vaccination_path(pet, vaccination)
      end.to change { pet.vaccinations.count }.by(-1)

      expect(response).to redirect_to(pet_vaccinations_path(pet))
      follow_redirect!
      expect(response.body).to include("Vacina removida com sucesso")
    end
  end

  context "quando usuário não é tutor" do
    let(:current_user) { create(:user) }

    it "não permite acessar" do
      expect do
        get pet_vaccinations_path(pet)
      end.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
