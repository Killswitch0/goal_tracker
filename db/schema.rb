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

ActiveRecord::Schema[7.0].define(version: 2024_02_27_165939) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "goal_id"
    t.bigint "user_id", null: false
    t.index ["goal_id"], name: "index_categories_on_goal_id"
    t.index ["user_id"], name: "index_categories_on_user_id"
  end

  create_table "challenge_goals", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "goal_id", null: false
    t.bigint "challenge_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "challenge_user_id", null: false
    t.index ["challenge_id"], name: "index_challenge_goals_on_challenge_id"
    t.index ["challenge_user_id"], name: "index_challenge_goals_on_challenge_user_id"
    t.index ["goal_id"], name: "index_challenge_goals_on_goal_id"
    t.index ["user_id"], name: "index_challenge_goals_on_user_id"
  end

  create_table "challenge_users", force: :cascade do |t|
    t.boolean "confirm", default: false
    t.bigint "user_id", null: false
    t.bigint "challenge_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["challenge_id"], name: "index_challenge_users_on_challenge_id"
    t.index ["user_id"], name: "index_challenge_users_on_user_id"
  end

  create_table "challenges", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "deadline"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_challenges_on_user_id"
  end

  create_table "completion_dates", force: :cascade do |t|
    t.date "date"
    t.bigint "habit_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["habit_id"], name: "index_completion_dates_on_habit_id"
  end

  create_table "goals", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.integer "days_completed", default: 0
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deadline"
    t.boolean "complete", default: false
    t.bigint "category_id", null: false
    t.string "color"
    t.integer "tasks_count", default: 0
    t.integer "tasks_completed_count", default: 0, null: false
    t.index ["category_id"], name: "index_goals_on_category_id"
    t.index ["user_id"], name: "index_goals_on_user_id"
  end

  create_table "habits", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "days_completed", default: 0
    t.bigint "user_id", null: false
    t.bigint "goal_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["goal_id"], name: "index_habits_on_goal_id"
    t.index ["user_id"], name: "index_habits_on_user_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.string "recipient_type", null: false
    t.bigint "recipient_id", null: false
    t.string "type", null: false
    t.jsonb "params"
    t.datetime "read_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["read_at"], name: "index_notifications_on_read_at"
    t.index ["recipient_type", "recipient_id"], name: "index_notifications_on_recipient"
  end

  create_table "tasks", force: :cascade do |t|
    t.string "name"
    t.boolean "complete", default: false
    t.bigint "goal_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.datetime "deadline"
    t.date "complete_date"
    t.index ["goal_id"], name: "index_tasks_on_goal_id"
    t.index ["user_id"], name: "index_tasks_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "email_confirmed", default: false
    t.string "confirm_token"
    t.string "auth_token"
    t.string "password_reset_token"
    t.datetime "password_reset_sent_at"
    t.integer "role", default: 0, null: false
    t.string "gravatar_hash"
    t.integer "tasks_count", default: 0
    t.index ["role"], name: "index_users_on_role"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "categories", "goals"
  add_foreign_key "categories", "users"
  add_foreign_key "challenge_goals", "challenge_users"
  add_foreign_key "challenge_goals", "challenges"
  add_foreign_key "challenge_goals", "goals"
  add_foreign_key "challenge_goals", "users"
  add_foreign_key "challenge_users", "challenges"
  add_foreign_key "challenge_users", "users"
  add_foreign_key "challenges", "users"
  add_foreign_key "completion_dates", "habits"
  add_foreign_key "goals", "categories"
  add_foreign_key "goals", "users"
  add_foreign_key "habits", "goals"
  add_foreign_key "habits", "users"
  add_foreign_key "tasks", "goals"
  add_foreign_key "tasks", "users"
end
