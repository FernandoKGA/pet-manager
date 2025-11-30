class AddPhotoFieldsToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :photo_base64, :text
    add_column :users, :photo_content_type, :string
    add_column :users, :photo_filename, :string
    add_column :users, :photo_size, :integer
  end
end
