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

ActiveRecord::Schema.define(version: 20150606182849) do

  create_table "items", force: true do |t|
    t.float    "x",          limit: 24
    t.float    "y",          limit: 24
    t.string   "keywords"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "person_values", force: true do |t|
    t.float    "x",                 limit: 24
    t.float    "y",                 limit: 24
    t.float    "influence",         limit: 24
    t.time     "availability_from"
    t.time     "availability_to"
    t.string   "keywords"
    t.float    "int_lvl",           limit: 24
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "from"
    t.datetime "to"
  end

  create_table "time_ranges", force: true do |t|
    t.integer  "owner_id"
    t.string   "owner_type"
    t.datetime "from",       null: false
    t.datetime "to",         null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "time_ranges", ["owner_id", "owner_type"], name: "index_time_ranges_on_owner_id_and_owner_type", using: :btree

  create_table "venue_person_values", force: true do |t|
    t.integer "venue_id"
    t.integer "person_value_id"
    t.float   "dist",            limit: 24
    t.float   "value",           limit: 24
  end

  create_table "venues", force: true do |t|
    t.float    "x",            limit: 24
    t.float    "y",            limit: 24
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "sum_dist",     limit: 24
    t.float    "sum_value",    limit: 24
    t.datetime "from"
    t.datetime "to"
    t.integer  "minimum_time",            null: false
  end

end
