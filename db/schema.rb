# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_03_17_150736) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "coordinates", force: :cascade do |t|
    t.integer "altitude"
    t.float "latitude"
    t.float "longitude"
    t.bigint "itinerary_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["itinerary_id"], name: "index_coordinates_on_itinerary_id"
  end

  create_table "itineraries", force: :cascade do |t|
    t.string "name"
    t.bigint "mountain_range_id"
    t.integer "elevation"
    t.text "departure"
    t.text "arrival"
    t.string "ascent_difficulty"
    t.string "ski_difficulty"
    t.text "description"
    t.time "duration"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["mountain_range_id"], name: "index_itineraries_on_mountain_range_id"
  end

  create_table "mountain_ranges", force: :cascade do |t|
    t.string "name"
    t.bigint "risk_level_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["risk_level_id"], name: "index_mountain_ranges_on_risk_level_id"
  end

  create_table "mountains", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reviews", force: :cascade do |t|
    t.integer "grade"
    t.string "comment"
    t.date "date"
    t.bigint "itinerary_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["itinerary_id"], name: "index_reviews_on_itinerary_id"
    t.index ["user_id"], name: "index_reviews_on_user_id"
  end

  create_table "risk_levels", force: :cascade do |t|
    t.date "bra_date"
    t.integer "risk1"
    t.integer "risk2"
    t.integer "evolrisk1"
    t.integer "evolrisk2"
    t.integer "altitude"
    t.text "exposures", default: [], array: true
    t.integer "risk_max"
    t.text "accidentel_text"
    t.text "naturel_text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "coordinates", "itineraries"
  add_foreign_key "itineraries", "mountain_ranges"
  add_foreign_key "mountain_ranges", "risk_levels"
  add_foreign_key "reviews", "itineraries"
  add_foreign_key "reviews", "users"
end
