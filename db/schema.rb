# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2025_10_01_001101) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "pets", force: :cascade do |t|
    t.string "name"
    t.date "birthdate"
    t.integer "size"
    t.string "species"
    t.string "breed"
    t.string "gender"
    t.string "sinpatinhas_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_pets_on_user_id"
  end

  create_table "reminder_notifications", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "pet_id", null: false
    t.string "title", null: false
    t.text "description"
    t.string "category", null: false
    t.integer "status", default: 0, null: false
    t.datetime "due_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["due_at"], name: "index_reminder_notifications_on_due_at"
    t.index ["pet_id"], name: "index_reminder_notifications_on_pet_id"
    t.index ["user_id", "status"], name: "index_reminder_notifications_on_user_id_and_status"
    t.index ["user_id"], name: "index_reminder_notifications_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", limit: 255
    t.string "first_name", limit: 255
    t.string "last_name", limit: 255
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_reset_token"
    t.datetime "password_reset_token_expires_at"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "pets", "users"
  add_foreign_key "reminder_notifications", "pets"
  add_foreign_key "reminder_notifications", "users"
end
