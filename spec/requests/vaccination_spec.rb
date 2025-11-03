require 'rails_helper'

RSpec.describe "Vaccinations", type: :request do
  let!(:user) { create(:user) }
  let!(:pet) { create(:pet, user: user) }
  let!(:vaccination) { create(:vaccination, pet: pet, name: "V8 Original") }
  
  let(:valid_attributes) { attributes_for(:vaccination, name: 'V10 Nova') }
  let(:invalid_attributes) { attributes_for(:vaccination, :invalid) }

  before do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
  end

  describe "GET /pets/:pet_id/vaccinations" do
    it "renders a successful response" do
      get pet_vaccinations_path(pet)
      expect(response).to be_successful
      expect(response.body).to include('V8 Original')
    end
  end

  describe "GET /pets/:pet_id/vaccinations/new" do
    it "renders a successful response" do
      get new_pet_vaccination_path(pet)
      expect(response).to be_successful
    end
  end

  describe "GET /pets/:pet_id/vaccinations/:id/edit" do
    it "renders a successful response" do
      get edit_pet_vaccination_path(pet, vaccination)
      expect(response).to be_successful
      expect(response.body).to include('V8 Original')
    end
  end

  describe "POST /pets/:pet_id/vaccinations" do
    context "with valid parameters" do
      it "creates a new Vaccination and redirects" do
        expect {
          post pet_vaccinations_path(pet), params: { vaccination: valid_attributes }
        }.to change(Vaccination, :count).by(1)
        
        expect(response).to redirect_to(pet_vaccinations_path(pet))
        follow_redirect!
        expect(response.body).to include('Vacinação cadastrada com sucesso.')
        expect(response.body).to include('V10 Nova')
      end
    end

    context "with invalid parameters" do
      it "does not create a new Vaccination and re-renders new" do
        expect {
          post pet_vaccinations_path(pet), params: { vaccination: invalid_attributes }
        }.to_not change(Vaccination, :count)
        
        expect(response).to have_http_status(:unprocessable_content)
        expect(response.body).to include("Não foi possível salvar as informações de vacinação do pet.")
      end
    end
  end

  describe "PATCH /pets/:pet_id/vaccinations/:id" do
    context "with valid parameters" do
      let(:new_attributes) { attributes_for(:vaccination, name: "Raiva (Atualizada)") }

      it "updates the vaccination and redirects" do
        patch pet_vaccination_path(pet, vaccination), params: { vaccination: new_attributes }
        vaccination.reload
        expect(vaccination.name).to eq("Raiva (Atualizada)")
        expect(response).to redirect_to(pet_vaccinations_path(pet))
        follow_redirect!
        expect(response.body).to include('Vacinação atualizada com sucesso.')
      end
    end

    context "with invalid parameters" do
      it "does not update and re-renders edit (and returns 422)" do
        patch pet_vaccination_path(pet, vaccination), params: { vaccination: invalid_attributes }
        vaccination.reload
        expect(vaccination.name).to eq("V8 Original")
        
        expect(response).to have_http_status(:unprocessable_content)
        expect(response.body).to include("field_with_errors")
      end
    end
  end

  describe "DELETE /pets/:pet_id/vaccinations/:id" do
    it "destroys the vaccination and redirects" do
      expect {
        delete pet_vaccination_path(pet, vaccination)
      }.to change(Vaccination, :count).by(-1)
      expect(response).to redirect_to(pet_vaccinations_path(pet))
      follow_redirect!
      expect(response.body).to include('Vacinação removida com sucesso.')
    end
  end
end