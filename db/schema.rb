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

ActiveRecord::Schema[7.1].define(version: 2025_11_01_161048) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "baths", force: :cascade do |t|
    t.bigint "pet_id", null: false
    t.datetime "date"
    t.decimal "price", precision: 8, scale: 2
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "tosa", default: false
    t.index ["pet_id"], name: "index_baths_on_pet_id"
  end

  create_table "diary_entries", force: :cascade do |t|
    t.text "content"
    t.datetime "entry_date"
    t.bigint "pet_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pet_id"], name: "index_diary_entries_on_pet_id"
  end

  create_table "expenses", force: :cascade do |t|
    t.decimal "amount"
    t.string "category"
    t.text "description"
    t.date "date"
    t.bigint "pet_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "bath_id"
    t.index ["bath_id"], name: "index_expenses_on_bath_id"
    t.index ["pet_id"], name: "index_expenses_on_pet_id"
    t.index ["user_id"], name: "index_expenses_on_user_id"
  end

  create_table "medical_appointments", force: :cascade do |t|
    t.bigint "pet_id", null: false
    t.string "veterinarian_name"
    t.datetime "appointment_date"
    t.string "clinic_address"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pet_id"], name: "index_medical_appointments_on_pet_id"
  end

  create_table "medications", force: :cascade do |t|
    t.bigint "pet_id", null: false
    t.string "name", null: false
    t.string "dosage", null: false
    t.string "frequency", null: false
    t.date "start_date", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pet_id"], name: "index_medications_on_pet_id"
  end

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
    t.text "photo_base64"
    t.string "photo_content_type"
    t.string "photo_filename"
    t.integer "photo_size"
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
    t.string "recurrence", default: "none", null: false
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

  create_table "vaccinations", force: :cascade do |t|
    t.string "name"
    t.date "applied_date"
    t.string "applied_by"
    t.boolean "applied"
    t.bigint "pet_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "pet_id", null: false
    t.string "vaccine_name", null: false
    t.date "administered_on", null: false
    t.date "next_due_on"
    t.string "dose"
    t.string "manufacturer"
    t.string "batch_number"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["next_due_on"], name: "index_vaccinations_on_next_due_on"
    t.index ["pet_id", "administered_on"], name: "index_vaccinations_on_pet_id_and_administered_on"
    t.index ["pet_id"], name: "index_vaccinations_on_pet_id"
  end

  create_table "weights", force: :cascade do |t|
    t.bigint "pet_id", null: false
    t.decimal "weight"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pet_id"], name: "index_weights_on_pet_id"
  end

  add_foreign_key "baths", "pets"
  add_foreign_key "diary_entries", "pets"
  add_foreign_key "expenses", "baths"
  add_foreign_key "expenses", "pets"
  add_foreign_key "expenses", "users"
  add_foreign_key "medical_appointments", "pets"
  add_foreign_key "medications", "pets"
  add_foreign_key "pets", "users"
  add_foreign_key "reminder_notifications", "pets"
  add_foreign_key "reminder_notifications", "users"
  add_foreign_key "vaccinations", "pets"
  add_foreign_key "weights", "pets"
end
