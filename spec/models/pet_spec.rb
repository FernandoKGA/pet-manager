# spec/models/pet_spec.rb
require 'rails_helper'

RSpec.describe Pet, type: :model do
  let(:user) { FactoryBot.create(:user) }
  
  # Usamos 'build' para testes de validação, pois não precisamos salvar no banco
  let(:pet) { 
    FactoryBot.build(:pet, user: user, name: 'Jorge', species: 'Cachorro', breed: 'Vira-lata') 
  }

  # Helpers para testes de fotos
  let(:sample_file) {
    Rack::Test::UploadedFile.new(
      Rails.root.join('spec/fixtures/files/bee.png'), 
      'image/png'
    )
  }
  # 1x1 pixel PNG (vermelho)
  let(:base64_image_data) { 'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEGQH/VLUadAAAAABJRU5ErkJggg==' }
  let(:base64_data_uri) { "data:image/png;base64,#{base64_image_data}" }

  describe 'validations' do
    it 'is valid with all required attributes' do
      expect(pet).to be_valid
    end

    it 'is invalid without a name' do
      pet.name = nil
      expect(pet).not_to be_valid
      expect(pet.errors[:name]).to include("can't be blank")
    end

    it 'is invalid without a species' do
      pet.species = nil
      expect(pet).not_to be_valid
      expect(pet.errors[:species]).to include("can't be blank")
    end

    it 'is invalid without a breed' do
      pet.breed = nil
      expect(pet).not_to be_valid
      expect(pet.errors[:breed]).to include("can't be blank")
    end

    it 'is invalid without a user' do
      pet.user = nil
      expect(pet).not_to be_valid
      expect(pet.errors[:user]).to include("must exist")
    end

    context 'when deceased' do
      it 'is invalid if deceased but has no date_of_death' do
        pet.deceased = true
        pet.date_of_death = nil
        expect(pet).not_to be_valid
        expect(pet.errors[:date_of_death]).to include("can't be blank")
      end

      it 'is valid if deceased and has a date_of_death' do
        pet.deceased = true
        pet.date_of_death = Date.today
        expect(pet).to be_valid
      end
    end

    it 'is valid if not deceased and has no date_of_death' do
      pet.deceased = false
      pet.date_of_death = nil
      expect(pet).to be_valid
    end

    context 'photo validations' do
      it 'is invalid with an invalid photo content type' do
        pet.photo_content_type = 'application/pdf'
        expect(pet).not_to be_valid
        expect(pet.errors[:photo_content_type]).to include("tipo inválido — permitido: png, jpg, jpeg")
      end

      it 'is valid with allowed photo content types' do
        %w(image/png image/jpg image/jpeg).each do |type|
          pet.photo_content_type = type
          pet.valid?
          expect(pet.errors[:photo_content_type]).to be_empty
        end
      end

      it 'is invalid if photo size exceeds 5MB' do
        pet.photo_size = 6.megabytes
        expect(pet).not_to be_valid
        expect(pet.errors[:photo_size]).to include("deve ser menor que 5 MB")
      end

      it 'is valid if photo size is within the limit' do
        pet.photo_size = 4.megabytes
        pet.valid?
        expect(pet.errors[:photo_size]).to be_empty
      end
    end
  end

  describe 'scopes' do
    context 'life status scopes' do
      # Usamos 'create' aqui pois scopes fazem queries no banco
      let!(:living_pet) { FactoryBot.create(:pet, user: user, deceased: false) }
      let!(:deceased_pet) { FactoryBot.create(:pet, user: user, deceased: true, date_of_death: 1.year.ago) }
      let!(:recent_deceased_pet) { FactoryBot.create(:pet, user: user, deceased: true, date_of_death: 1.month.ago) }

      it '.living' do
        expect(Pet.living).to contain_exactly(living_pet)
      end

      it '.deceased' do
        expect(Pet.deceased).to contain_exactly(deceased_pet, recent_deceased_pet)
      end

      it '.ordered_by_death_date' do
        expect(Pet.deceased.ordered_by_death_date).to eq([recent_deceased_pet, deceased_pet])
      end
    end

    context 'activation scopes' do
      let!(:active_pet) { FactoryBot.create(:pet, user: user, active: true) }
      let!(:inactive_pet) { FactoryBot.create(:pet, user: user, active: false) }

      it '.active returns only active pets' do
        expect(Pet.active).to contain_exactly(active_pet)
      end

      it '.inactive returns only inactive pets' do
        expect(Pet.inactive).to contain_exactly(inactive_pet)
      end
    end
  end

  describe 'methods' do
    describe '#current_weight' do
      let(:saved_pet) { FactoryBot.create(:pet, user: user) }

      it 'returns nil if there are no weights' do
        expect(saved_pet.current_weight).to be_nil
      end

      it 'returns the latest weight' do
        FactoryBot.create(:weight, pet: saved_pet, weight: 10.5, created_at: 2.days.ago)
        FactoryBot.create(:weight, pet: saved_pet, weight: 11.0, created_at: 1.day.ago)

        expect(saved_pet.current_weight).to eq(11.0)
      end
    end
  end

  describe 'photo handling' do
    it '#attach_uploaded_file attaches an uploaded file' do
      pet.attach_uploaded_file(sample_file)

      expect(pet.photo_attached?).to be(true)
      expect(pet.photo_content_type).to eq('image/png')
      expect(pet.photo_filename).to eq('bee.png')
      expect(pet.photo_size).to be > 0
    end

    describe '#attach_base64_string' do
      it 'attaches from a data URI' do
        pet.attach_base64_string(base64_data_uri, filename: 'pixel.png')
        
        expect(pet.photo_attached?).to be(true)
        expect(pet.photo_content_type).to eq('image/png')
        expect(pet.photo_filename).to eq('pixel.png')
        expect(pet.photo_base64).to eq(base64_image_data)
        expect(pet.photo_size).to be > 0
      end

      it 'attaches from a raw base64 string' do
        pet.attach_base64_string(base64_image_data, filename: 'raw.png')
        
        expect(pet.photo_content_type).to be_nil # Não é possível inferir o tipo
        expect(pet.photo_filename).to eq('raw.png')
        expect(pet.photo_base64).to eq(base64_image_data)
      end
    end

    describe '#photo_data_uri' do
      it 'returns nil if no photo is attached' do
        pet.photo_base64 = nil
        expect(pet.photo_data_uri).to be_nil
      end

      it 'returns a formatted data URI' do
        pet.photo_base64 = base64_image_data
        pet.photo_content_type = 'image/png'
        
        expect(pet.photo_data_uri).to eq("data:image/png;base64,#{base64_image_data}")
      end
    end

    describe '#remove_photo!' do
      it 'clears all photo attributes' do
        pet.attach_uploaded_file(sample_file)
        pet.save! # Salva para testar persistência
        
        expect(pet.photo_attached?).to be(true)
        
        pet.remove_photo!
        
        expect(pet.photo_attached?).to be(false)
        expect(pet.photo_base64).to be_nil
        expect(pet.photo_content_type).to be_nil
        expect(pet.photo_filename).to be_nil
        expect(pet.photo_size).to be_nil
      end
    end
  end
end
