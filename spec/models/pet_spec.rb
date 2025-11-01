# spec/models/pet_spec.rb
require 'rails_helper'

RSpec.describe Pet, type: :model do
  let(:user) { FactoryBot.create(:user) }

  describe 'validations' do
    it 'is valid with all required attributes' do
      pet = Pet.new(
        name:    'Jorge',
        species: 'Cachorro',
        breed:   'Vira-lata',
        user:    user
      )
      expect(pet).to be_valid
    end

    it 'is invalid without a name' do
      pet = Pet.new(name: nil, species: 'Cachorro', breed: 'Vira-lata', user: user)
      expect(pet).not_to be_valid
      expect(pet.errors[:name]).to include("can't be blank")
    end

    it 'is invalid without a species' do
      pet = Pet.new(name: 'Jorge', species: nil, breed: 'Vira-lata', user: user)
      expect(pet).not_to be_valid
      expect(pet.errors[:species]).to include("can't be blank")
    end

    it 'is invalid without a breed' do
      pet = Pet.new(name: 'Jorge', species: 'Cachorro', breed: nil, user: user)
      expect(pet).not_to be_valid
      expect(pet.errors[:breed]).to include("can't be blank")
    end

    it 'is invalid without a user' do
      pet = Pet.new(name: 'Jorge', species: 'Cachorro', breed: 'Vira-lata', user: nil)
      expect(pet).not_to be_valid
      expect(pet.errors[:user]).to include("must exist")
    end
  end
  

  describe 'photo attachment' do
    it 'attaches an uploaded file' do
      pet = Pet.new(name: 'Jorge', species: 'Cachorro', breed: 'Vira-lata', user: user)

      file = Rack::Test::UploadedFile.new(
        Rails.root.join('spec/fixtures/files/bee.png'), 
        'image/png'
      )

      pet.attach_uploaded_file(file)
      expect(pet.photo_attached?).to be(true)
      expect(pet.photo_content_type).to eq('image/png')
      expect(pet.photo_filename).to eq('bee.png')
      expect(pet.photo_size).to be > 0
    end
  end


end
