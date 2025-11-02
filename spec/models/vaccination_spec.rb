require 'rails_helper'

RSpec.describe Vaccination, type: :model do
  it "é válido com atributos mínimos" do
    vaccination = build(:vaccination)
    expect(vaccination).to be_valid
  end

  it "exige nome da vacina" do
    vaccination = build(:vaccination, vaccine_name: nil)
    expect(vaccination).not_to be_valid
  end

  it "exige data de aplicação" do
    vaccination = build(:vaccination, administered_on: nil)
    expect(vaccination).not_to be_valid
  end

  describe '.upcoming' do
    it "retorna vacinas com próxima dose futura" do
      future = create(:vaccination, next_due_on: Date.current + 5.days)
      create(:vaccination, next_due_on: Date.current - 1.day)

      expect(Vaccination.upcoming).to contain_exactly(future)
    end
  end
end
