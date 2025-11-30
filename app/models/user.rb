class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: { case_sensitive: false }
  validates :first_name, presence: true, length: { maximum: 255 }
  validates :last_name, presence: true, length: { maximum: 255 }

  has_many :pets, dependent: :destroy
  has_many :reminder_notifications, dependent: :destroy
  has_many :expenses, dependent: :destroy

  validate :photo_content_type_whitelist
  validate :photo_size_limit

  def photo_attached?
    photo_base64.present?
  end

  def photo_data_uri
    return nil unless photo_attached?
    "data:#{photo_content_type};base64,#{photo_base64}"
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

  private

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
