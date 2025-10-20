require 'rails_helper'

RSpec.describe DiaryEntry, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:pet) { FactoryBot.create(:pet, user: user) }

  context 'associations' do
    it { should belong_to(:pet) }
  end

  context 'validations' do
    it 'is valid with valid attributes' do
      diary_entry = create(:diary_entry, pet: pet)
      expect(diary_entry).to be_valid
    end

    it 'is not valid without content' do
      diary_entry = build(:diary_entry, content: nil)
      expect(diary_entry).not_to be_valid
      expect(diary_entry.errors[:content]).to include("can't be blank")
    end

    it 'is not valid without an entry_date' do
      diary_entry = build(:diary_entry, entry_date: nil)
      expect(diary_entry).not_to be_valid
      expect(diary_entry.errors[:entry_date]).to include("can't be blank")
    end

    it 'is not valid without a pet' do
      diary_entry = build(:diary_entry, pet: nil)
      expect(diary_entry).not_to be_valid
      expect(diary_entry.errors[:pet]).to include('must exist')
    end
  end
end

