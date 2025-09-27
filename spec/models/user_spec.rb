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
    expect(user.errors[:email]).to include(I18n.t('activerecord.errors.messages.blank'))
  end

  it 'is invalid without a first name' do
    user = User.new(first_name: nil)
    expect(user).not_to be_valid
    expect(user.errors[:first_name]).to include(I18n.t('activerecord.errors.messages.blank'))
  end

  it 'is invalid without a last name' do
    user = User.new(last_name: nil)
    expect(user).not_to be_valid
    expect(user.errors[:last_name]).to include(I18n.t('activerecord.errors.messages.blank'))
  end
end
