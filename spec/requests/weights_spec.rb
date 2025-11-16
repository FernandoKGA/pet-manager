require 'rails_helper'

RSpec.describe "Weights", type: :request do
  let(:owner) { create(:user) }
  let(:pet) { create(:pet, user: owner) }
  let(:current_user) { owner }

  before do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(current_user)
  end

  describe "GET /pets/:pet_id/weight" do
    context "quando o tutor acessa" do
      it "retorna sucesso" do
        create(:weight, pet: pet, weight: 4.5)

        get pet_weights_path(pet)

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Diário de peso")
      end
    end

    context "quando o veterinário acessa" do
      let(:current_user) { create(:user, :veterinarian) }

      it "retorna sucesso" do
        create(:weight, pet: pet, weight: 4.5)

        get pet_weights_path(pet)

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Diário de peso")
      end

      it "filtra por período quando informado" do
        older = create(:weight, pet: pet, weight: 4.5, created_at: 5.days.ago)
        recent = create(:weight, pet: pet, weight: 5.2, created_at: Date.today)

        get pet_weights_path(pet), params: { start_date: Date.today.strftime("%Y-%m-%d") }

        expect(response.body).to include(sprintf("%0.2f", recent.weight))
        expect(response.body).not_to include(sprintf("%0.2f", older.weight))
      end

      it "exibe mensagem para data inválida" do
        get pet_weights_path(pet), params: { start_date: "31-99-2025" }

        expect(response.body).to include("Data inicial inválida")
      end
    end
  end

  describe "POST /pets/:pet_id/weight" do
    context "quando o tutor registra um novo peso" do
      it "cria o registro" do
        expect do
          post pet_weights_path(pet), params: { weight: { weight: 7.3 } }
        end.to change { pet.weights.reload.count }.by(1)

        expect(response).to redirect_to(pet_weights_path(pet))
        follow_redirect!
        expect(response.body).to include("Peso atualizado com sucesso")
      end
    end

    context "quando o veterinário tenta registrar" do
      let(:current_user) { create(:user, :veterinarian) }

      it "bloqueia a ação" do
        expect do
          post pet_weights_path(pet), params: { weight: { weight: 7.3 } }
        end.not_to change { pet.weights.reload.count }

        expect(response).to redirect_to(pet_weights_path(pet))
        follow_redirect!
        expect(response.body).to include("Somente o tutor pode registrar novos pesos")
      end
    end
  end
end
