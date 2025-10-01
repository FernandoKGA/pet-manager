class AddPasswordResetTokenToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :password_reset_token, :string
    add_column :users, :password_reset_token_expires_at, :datetime
  end
end
