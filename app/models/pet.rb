# app/models/pet.rb
class Pet < ApplicationRecord

  validates :name, presence: true, length: {maximum: 255}
  validates :species, presence: true, length: {maximum: 255}
  validates :breed, presence: true, length: {maximum: 255}

  belongs_to :user
  has_many :medications, dependent: :destroy
  has_many :reminder_notifications, dependent: :destroy
  has_many :expenses, dependent: :destroy
  has_many :weights, dependent: :destroy
  has_many :diary_entries, dependent: :destroy

  validate :photo_content_type_whitelist
  validate :photo_size_limit

  def current_weight
    weights.order(created_at: :desc).first&.weight
  end

  def photo_attached?
    photo_base64.present?
  end

  def photo_data_uri
    return nil unless photo_attached?
    "data:#{photo_content_type};base64,#{photo_base64}"
  end


  def photo_size_bytes
    photo_size
  end

  def remove_photo!
    update!(
      photo_base64: nil,
      photo_content_type: nil,
      photo_filename: nil,
      photo_size: nil
    )
  end

  def attach_uploaded_file(uploaded_io)
    return unless uploaded_io.respond_to?(:read)


    bin = uploaded_io.read

    self.photo_base64 = Base64.strict_encode64(bin)
    self.photo_content_type = uploaded_io.content_type
    self.photo_filename = uploaded_io.original_filename
    self.photo_size = bin.bytesize

    if uploaded_io.respond_to?(:tempfile) && uploaded_io.tempfile && !uploaded_io.tempfile.closed?
      uploaded_io.tempfile.close
    end
    self
  end

  def attach_base64_string(data_uri_or_base64, filename: nil)
    if data_uri_or_base64 =~ /\Adata:(.*?);base64,(.*)\z/m
      self.photo_content_type = Regexp.last_match(1)
      base64_str = Regexp.last_match(2)
    else
      base64_str = data_uri_or_base64
    end

    decoded = Base64.decode64(base64_str)
    self.photo_base64 = Base64.strict_encode64(decoded) 
    self.photo_size = decoded.bytesize
    self.photo_filename = filename if filename.present?
    self
  end

  private

  # aqui pdemos ajustar os tipos de arquivo
  def photo_content_type_whitelist
    return if photo_content_type.blank?
    allowed = %w(image/png image/jpg image/jpeg)
    unless allowed.include?(photo_content_type)
      errors.add(:photo_content_type, "tipo inválido — permitido: png, jpg, jpeg")
    end
  end

  def photo_size_limit
    return if photo_size.blank?
    max = 5.megabytes
    if photo_size > max
      errors.add(:photo_size, "deve ser menor que #{ActiveSupport::NumberHelper.number_to_human_size(max)}")
    end
  end
end
