require 'rails_helper'

RSpec.describe Weight, type: :model do
  describe 'associations' do
    it { should belong_to(:pet) }
  end

  describe 'validations' do
    it { should validate_presence_of(:weight) }

    it { should validate_numericality_of(:weight).is_greater_than(0) }
  end
end
