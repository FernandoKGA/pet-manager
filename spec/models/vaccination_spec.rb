require 'rails_helper'

RSpec.describe Vaccination, type: :model do
  
  describe 'associations' do
    it { should belong_to(:pet) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:applied_date) }

    it 'is valid with valid attributes' do
      expect(build(:vaccination)).to be_valid
    end

    it 'is invalid without a name' do
      vaccination = build(:vaccination, name: nil)
      expect(vaccination).not_to be_valid
      expect(vaccination.errors[:name]).to include("can't be blank")
    end

    it 'is invalid without an applied_date' do
      vaccination = build(:vaccination, applied_date: nil)
      expect(vaccination).not_to be_valid
      expect(vaccination.errors[:applied_date]).to include("can't be blank")
    end
  end
end