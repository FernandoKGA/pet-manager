class PasswordReset
  include ActiveModel::Model

  attr_accessor :user, :email

  def save
    @user = User.find_by(email: email)
    if @user
      @user.password_reset_token = SecureRandom.urlsafe_base64
      @user.password_reset_token_expires_at = 24.hours.from_now
      @user.save
      UserMailer.password_reset(@user).deliver_later
    end
  end

  def self.find_by_valid_token(token)
    User.where("password_reset_token = ? AND password_reset_token_expires_at > ?", token, Time.now).first #exploitable, melhorar
  end
end