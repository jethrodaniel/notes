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

ActiveRecord::Schema[8.0].define(version: 2025_08_16_050502) do
  create_table "notes", id: { type: :string, limit: 36, default: -> { "uuid()" } }, force: :cascade do |t|
    t.text "content", null: false
    t.string "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "title"
    t.index ["user_id"], name: "index_notes_on_user_id"
  end

  create_table "preferences", id: { type: :string, limit: 36, default: -> { "uuid()" } }, force: :cascade do |t|
    t.string "user_id", null: false
    t.string "language", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "note_index_truncate_length", default: 280, null: false
    t.index ["user_id"], name: "index_preferences_on_user_id", unique: true
  end

  create_table "sessions", id: { type: :string, limit: 36, default: -> { "uuid()" } }, force: :cascade do |t|
    t.string "user_id", null: false
    t.string "ip_address"
    t.string "user_agent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "users", id: { type: :string, limit: 36, default: -> { "uuid()" } }, force: :cascade do |t|
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "language", default: "en", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  add_foreign_key "notes", "users"
  add_foreign_key "preferences", "users"
  add_foreign_key "sessions", "users"

  # Virtual tables defined in this database.
  # Note that virtual tables may not work with other database engines. Be careful if changing database.
  create_virtual_table "notes_full_text_search", "fts5", ["note_id", "title", "content"]
end
