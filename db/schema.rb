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

ActiveRecord::Schema.define(version: 20141125153312) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accommodations", force: true do |t|
    t.string   "name"
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "description"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  create_table "accommodations_equipments", id: false, force: true do |t|
    t.integer "accommodation_id"
    t.integer "equipment_id"
  end

  create_table "addresses", force: true do |t|
    t.string   "country"
    t.string   "zip"
    t.string   "city"
    t.string   "address"
    t.integer  "accommodation_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categries", force: true do |t|
    t.string   "name"
    t.string   "code"
    t.integer  "value"
    t.integer  "accommodation_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "coordinates", force: true do |t|
    t.float    "latitude"
    t.float    "longitude"
    t.integer  "address_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "equipment", force: true do |t|
    t.string   "name"
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "prices", force: true do |t|
    t.float    "value"
    t.string   "currency"
    t.float    "ifa"
    t.float    "vat"
    t.integer  "room_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rooms", force: true do |t|
    t.string   "name"
    t.string   "code"
    t.integer  "accommodation_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "num_of_this"
    t.integer  "capacity"
    t.integer  "description"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

end
