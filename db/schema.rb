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


ActiveRecord::Schema.define(version: 2020_03_23_193549) do

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
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "beras", force: :cascade do |t|
    t.date "bra_date"
    t.integer "risk1"
    t.integer "risk2"
    t.integer "evolrisk1"
    t.integer "evolrisk2"
    t.integer "altitude"
    t.boolean "exposure_ne"
    t.boolean "exposure_e"
    t.boolean "exposure_s"
    t.boolean "exposure_se"
    t.boolean "exposure_sw"
    t.boolean "exposure_n"
    t.boolean "exposure_nw"
    t.boolean "exposure_w"
    t.text "comment"
    t.integer "risk_max"
    t.text "accidentel_text"
    t.text "naturel_text"
    t.bigint "mountain_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["mountain_id"], name: "index_beras_on_mountain_id"
  end

  create_table "coordinates", force: :cascade do |t|
    t.integer "altitude"
    t.float "latitude"
    t.float "longitude"
    t.bigint "itinerary_id"
    t.integer "order"
    t.string "color"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "evol_color"
    t.index ["itinerary_id"], name: "index_coordinates_on_itinerary_id"
  end

  create_table "favorites", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "itinerary_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["itinerary_id"], name: "index_favorites_on_itinerary_id"
    t.index ["user_id"], name: "index_favorites_on_user_id"
  end

  create_table "itineraries", force: :cascade do |t|
    t.string "name"
    t.integer "elevation"
    t.string "departure"
    t.string "arrival"
    t.string "ascent_difficulty"
    t.string "ski_difficulty"
    t.text "description"
    t.integer "duration"
    t.bigint "mountain_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "terrain_difficulty"
    t.index ["mountain_id"], name: "index_itineraries_on_mountain_id"
    t.index ["user_id"], name: "index_itineraries_on_user_id"
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

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin", default: false
    t.string "username"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "beras", "mountains"
  add_foreign_key "coordinates", "itineraries"
  add_foreign_key "favorites", "itineraries"
  add_foreign_key "favorites", "users"
  add_foreign_key "itineraries", "mountains"
  add_foreign_key "itineraries", "users"
  add_foreign_key "reviews", "itineraries"
  add_foreign_key "reviews", "users"
end
