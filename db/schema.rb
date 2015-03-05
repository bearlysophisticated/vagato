# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20150212120006) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accommodation_equipments", force: :cascade do |t|
    t.integer  "accommodation_id"
    t.integer  "equipment_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "accommodations", force: :cascade do |t|
    t.string   "name"
    t.string   "code"
    t.text     "description"
    t.integer  "owner_id"
    t.integer  "categry_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  create_table "accommodations_serviices", id: false, force: :cascade do |t|
    t.integer "accommodation_id"
    t.integer "serviice_id"
  end

  create_table "addresses", force: :cascade do |t|
    t.string   "country"
    t.string   "zip"
    t.string   "city"
    t.string   "address"
    t.float    "latitude"
    t.float    "longitude"
    t.integer  "addressable_id"
    t.string   "addressable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "admins", force: :cascade do |t|
    t.string   "name"
    t.string   "phone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "bookings", force: :cascade do |t|
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "num_of_nights"
    t.string   "state"
    t.integer  "guest_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "bookings_guests", force: :cascade do |t|
    t.integer  "guest_id"
    t.integer  "booking_id"
    t.integer  "room_id"
    t.string   "role"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bookings_rooms", force: :cascade do |t|
    t.integer  "booking_id"
    t.integer  "room_id"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categries", force: :cascade do |t|
    t.string   "name"
    t.string   "code"
    t.integer  "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "equipment", force: :cascade do |t|
    t.string   "name"
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "equipment_rooms", force: :cascade do |t|
    t.integer  "room_id"
    t.integer  "equipment_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "guests", force: :cascade do |t|
    t.string   "name"
    t.string   "phone"
    t.date     "day_of_birth"
    t.integer  "guest_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "owners", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "prices", force: :cascade do |t|
    t.float    "value"
    t.string   "currency"
    t.float    "ifa"
    t.float    "vat"
    t.integer  "room_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rooms", force: :cascade do |t|
    t.string   "name"
    t.string   "code"
    t.integer  "accommodation_id"
    t.integer  "num_of_this"
    t.integer  "capacity"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  create_table "serviices", force: :cascade do |t|
    t.string   "name"
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "role_type"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
