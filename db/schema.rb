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

ActiveRecord::Schema.define(version: 20150524145933) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "key_results", force: :cascade do |t|
    t.string   "description"
    t.decimal  "score",        precision: 2, scale: 1, default: 0.5
    t.text     "review"
    t.integer  "objective_id"
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
  end

  add_index "key_results", ["objective_id"], name: "index_key_results_on_objective_id", using: :btree

  create_table "objectives", force: :cascade do |t|
    t.string   "description"
    t.decimal  "score",       precision: 2, scale: 1, default: 0.5
    t.text     "review"
    t.integer  "okr_id"
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
  end

  add_index "objectives", ["okr_id"], name: "index_objectives_on_okr_id", using: :btree

  create_table "okrs", force: :cascade do |t|
    t.string   "admin_name"
    t.string   "admin_email"
    t.string   "admin_url"
    t.string   "public_url"
    t.string   "owner"
    t.integer  "year"
    t.integer  "quarter"
    t.decimal  "score",       precision: 2, scale: 1
    t.boolean  "reviewed",                            default: false
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
  end

end
