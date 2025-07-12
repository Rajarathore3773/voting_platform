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

ActiveRecord::Schema[7.2].define(version: 2025_07_10_152250) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "candidates", force: :cascade do |t|
    t.string "name"
    t.bigint "election_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["election_id"], name: "index_candidates_on_election_id"
  end

  create_table "delegations", force: :cascade do |t|
    t.bigint "election_id", null: false
    t.integer "delegator_id"
    t.integer "delegate_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["election_id"], name: "index_delegations_on_election_id"
  end

  create_table "elections", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.datetime "start_time"
    t.datetime "end_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ranked_ballots", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "election_id", null: false
    t.text "rankings"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["election_id"], name: "index_ranked_ballots_on_election_id"
    t.index ["user_id"], name: "index_ranked_ballots_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.string "phone_number"
    t.boolean "phone_verified"
    t.string "phone_verification_code"
    t.datetime "phone_verification_sent_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["phone_number"], name: "index_users_on_phone_number", unique: true
  end

  add_foreign_key "candidates", "elections"
  add_foreign_key "delegations", "elections"
  add_foreign_key "ranked_ballots", "elections"
  add_foreign_key "ranked_ballots", "users"
end
