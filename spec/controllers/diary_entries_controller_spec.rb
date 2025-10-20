require 'rails_helper'

include SessionsHelper

RSpec.describe "DiaryEntries", type: :request do
  let!(:user) { FactoryBot.create(:user) }
  let!(:other_user) { FactoryBot.create(:user, email: "test2@petmanager.com") }

  let!(:pet) { FactoryBot.create(:pet, user: user) }
  let!(:other_pet) { FactoryBot.create(:pet, user: other_user) }

  before do
    allow_any_instance_of(ApplicationController).to receive(:logged_in?).and_return(true)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
  end

  describe "GET /pets/:pet_id/diary_entries" do
    let!(:entry1) { create(:diary_entry, pet: pet, content: "First Entry", entry_date: 2.days.ago) }
    let!(:entry2) { create(:diary_entry, pet: pet, content: "Second Entry", entry_date: 1.day.ago) }
    let!(:other_entry) { create(:diary_entry, pet: other_pet, content: "Other Pet's Entry") }

    it "succeeds and renders the index template" do
      get pet_diary_entries_path(pet)
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Diário de #{pet.name}")
    end

    it "displays the pet's diary entries, ordered by most recent first" do
      get pet_diary_entries_path(pet)

      expect(response.body).to include(entry1.content)
      expect(response.body).to include(entry2.content)

      expect(response.body.index(entry2.content)).to be < response.body.index(entry1.content)
    end

    it "does not display entries from another user's pet" do
      get pet_diary_entries_path(pet)
      expect(response.body).not_to include(other_entry.content)
    end

    context "when filtering by date" do
      let!(:filtered_entry) { create(:diary_entry, pet: pet, content: "Filtered Entry", entry_date: Date.today) }

      it "only displays entries from the selected date" do
        get pet_diary_entries_path(pet, params: { filter_date: Date.today.to_s })
        
        expect(response.body).to include(filtered_entry.content)
        expect(response.body).not_to include(entry1.content)
        expect(response.body).not_to include(entry2.content)
      end
    end
  end

  describe "POST /pets/:pet_id/diary_entries" do
    context "with valid parameters" do
      let(:valid_params) do
        { diary_entry: { content: "A new diary entry.", entry_date: Time.current } }
      end

      it "creates a new DiaryEntry for the pet" do
        expect {
          post pet_diary_entries_path(pet), params: valid_params
        }.to change(pet.diary_entries, :count).by(1)
      end

      it "redirects to the diary entries index page" do
        post pet_diary_entries_path(pet), params: valid_params
        expect(response).to redirect_to(pet_diary_entries_path(pet))
      end

      it "sets a success flash notice" do
        post pet_diary_entries_path(pet), params: valid_params
        expect(flash[:notice]).to eq('Entrada do diário adicionada com sucesso!')
      end
    end

    context "with invalid parameters" do
      let(:invalid_params) do
        { diary_entry: { content: "", entry_date: Time.current } }
      end

      it "does not create a new DiaryEntry" do
        expect {
          post pet_diary_entries_path(pet), params: invalid_params
        }.not_to change(DiaryEntry, :count)
      end

      it "re-renders the index template with an unprocessable_content status" do
        post pet_diary_entries_path(pet), params: invalid_params
        expect(response).to have_http_status(:unprocessable_content)
        expect(response.body).to include("Diário de #{pet.name}")
      end
    end
  end

  describe "DELETE /pets/:pet_id/diary_entries/:id" do
    let!(:entry_to_delete) { create(:diary_entry, pet: pet) }
    let!(:other_users_entry) { create(:diary_entry, pet: other_pet) }

    it "deletes the specified diary entry" do
      expect {
        delete pet_diary_entry_path(pet, entry_to_delete)
      }.to change(pet.diary_entries, :count).by(-1)
    end

    it "redirects to the diary entries index page" do
      delete pet_diary_entry_path(pet, entry_to_delete)
      expect(response).to redirect_to(pet_diary_entries_path(pet))
    end

    it "sets a success flash notice" do
      delete pet_diary_entry_path(pet, entry_to_delete)
      expect(flash[:notice]).to eq('Entrada do diário removida com sucesso.')
    end
  end
end
