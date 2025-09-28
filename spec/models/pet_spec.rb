require 'rails_helper'

RSpec.describe Pet, type: :model do
  let(:user) { FactoryBot.create(:user) }
  it 'is valid with all required attributes' do
    pet = Pet.new(
      name:      'Jorge',
      species: 'Cachorro',
      breed:  'Vira-lata',
      user_id: user.id,
    )
    expect(pet).to be_valid
  end

  it 'is invalid without an name' do
    pet = Pet.new(name: nil)
    expect(pet).not_to be_valid
    expect(pet.errors[:name]).to include("can't be blank")
  end

  it 'name invalid without a species' do
    pet = Pet.new(species: nil)
    expect(pet).not_to be_valid
    expect(pet.errors[:species]).to include("can't be blank")
  end

  it 'is invalid without a breed' do
    pet = Pet.new(breed: nil)
    expect(pet).not_to be_valid
    expect(pet.errors[:breed]).to include("can't be blank")
  end

  it 'is invalid without a user' do
    pet = Pet.new(user_id: nil)
    expect(pet).not_to be_valid
    expect(pet.errors[:user]).to include("must exist")
  end
end
