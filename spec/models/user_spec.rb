require 'rails_helper'

RSpec.describe User, type: :model do
  it 'is valid with all required attributes' do
    user = User.new(
      email:      'teste@petmanager.com',
      first_name: 'Bob',
      last_name:  'Burnquist',
      password:   'secret123',
    )
    expect(user).to be_valid
  end

  it 'is invalid without an email' do
    user = User.new(email: nil)
    expect(user).not_to be_valid
    expect(user.errors[:email]).to include("can't be blank")
  end

  it 'is invalid without a first name' do
    user = User.new(first_name: nil)
    expect(user).not_to be_valid
    expect(user.errors[:first_name]).to include("can't be blank")
  end

  it 'is invalid without a last name' do
    user = User.new(last_name: nil)
    expect(user).not_to be_valid
    expect(user.errors[:last_name]).to include("can't be blank")
  end

  describe 'photo validations' do
    let(:user) {
      User.new(
        email: 'photo@test.com',
        first_name: 'A',
        last_name: 'B',
        password: '123456'
      )
    }

    it 'accepts valid content types' do
      user.photo_content_type = 'image/png'
      user.photo_size = 1000

      expect(user).to be_valid
    end

    it 'rejects invalid content types' do
      user.photo_content_type = 'application/pdf'
      user.photo_size = 1000

      expect(user).not_to be_valid
      expect(user.errors[:photo_content_type]).to include(/inválido/)
    end

    it 'rejects files larger than 5MB' do
      user.photo_content_type = 'image/png'
      user.photo_size = 6.megabytes

      expect(user).not_to be_valid
      expect(user.errors[:photo_size]).to be_present
    end
  end

  describe '#photo_attached?' do
    it 'returns true when base64 exists' do
      user = User.new(photo_base64: 'abc')
      expect(user.photo_attached?).to be true
    end

    it 'returns false when base64 is nil' do
      expect(User.new.photo_attached?).to be false
    end
  end

  describe '#photo_data_uri' do
    it 'returns nil when no photo is attached' do
      expect(User.new.photo_data_uri).to be_nil
    end

    it 'returns a valid data URI string' do
      user = User.new(photo_base64: 'AAAA', photo_content_type: 'image/png')
      expect(user.photo_data_uri).to eq("data:image/png;base64,AAAA")
    end
  end

  describe '#remove_photo!' do
    it 'clears all photo fields' do
      user = User.create!(
        email: 'remove@test.com',
        first_name: 'A',
        last_name: 'B',
        password: '123456',
        photo_base64: 'aaa',
        photo_content_type: 'image/png',
        photo_filename: 'test.png',
        photo_size: 123
      )

      user.remove_photo!
      user.reload

      expect(user.photo_base64).to be_nil
      expect(user.photo_content_type).to be_nil
      expect(user.photo_filename).to be_nil
      expect(user.photo_size).to be_nil
    end
  end
end
