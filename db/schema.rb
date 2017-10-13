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

ActiveRecord::Schema.define(version: 20171013134439) do

  create_table "acquisitions", force: :cascade do |t|
    t.text     "reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "allocations", force: :cascade do |t|
    t.text     "reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "items", force: :cascade do |t|
    t.string   "shortDescription"
    t.text     "longDescription"
    t.float    "value"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "operators", force: :cascade do |t|
    t.string   "name"
    t.string   "login"
    t.string   "email"
    t.string   "password_digest"
    t.boolean  "canAlocate"
    t.boolean  "canBuy"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "placements", force: :cascade do |t|
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

end
