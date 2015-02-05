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

ActiveRecord::Schema.define(version: 20150205124505) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "agents", force: :cascade do |t|
    t.string   "name"
    t.string   "company"
    t.string   "mobile"
    t.string   "email"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
  end

  create_table "photos", force: :cascade do |t|
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "photos", ["owner_type", "owner_id"], name: "index_photos_on_owner_type_and_owner_id", using: :btree

  create_table "properties", force: :cascade do |t|
    t.string   "name"
    t.string   "property_type"
    t.integer  "price"
    t.integer  "size"
    t.text     "description"
    t.string   "postal_code"
    t.string   "street"
    t.integer  "bedrooms"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "baths"
    t.integer  "tenure"
    t.string   "developer"
    t.string   "condition"
    t.integer  "agent_id"
  end

  add_index "properties", ["agent_id"], name: "index_properties_on_agent_id", using: :btree

end
