class AddPhotoBase64ToPets < ActiveRecord::Migration[7.1]
  def change
    add_column :pets, :photo_base64, :text
    add_column :pets, :photo_content_type, :string
    add_column :pets, :photo_filename, :string
    add_column :pets, :photo_size, :integer
  end
end
