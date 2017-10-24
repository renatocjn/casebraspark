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

ActiveRecord::Schema.define(version: 20171024180034) do

  create_table "acquisitions", force: :cascade do |t|
    t.text     "reason"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "supplier"
    t.integer  "operator_id"
  end

  add_index "acquisitions", ["operator_id"], name: "index_acquisitions_on_operator_id"

  create_table "allocations", force: :cascade do |t|
    t.text     "reason"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "acquisition_id"
    t.integer  "operator_id"
    t.integer  "placement_id"
  end

  add_index "allocations", ["acquisition_id"], name: "index_allocations_on_acquisition_id"
  add_index "allocations", ["operator_id"], name: "index_allocations_on_operator_id"
  add_index "allocations", ["placement_id"], name: "index_allocations_on_placement_id"

  create_table "allocations_items", id: false, force: :cascade do |t|
    t.integer "allocation_id", null: false
    t.integer "item_id",       null: false
  end

  add_index "allocations_items", ["allocation_id", "item_id"], name: "index_allocations_items_on_allocation_id_and_item_id"
  add_index "allocations_items", ["item_id", "allocation_id"], name: "index_allocations_items_on_item_id_and_allocation_id"

  create_table "item_types", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "items", force: :cascade do |t|
    t.string   "plate"
    t.string   "brand"
    t.string   "model"
    t.string   "serial"
    t.text     "longDescription"
    t.float    "value"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.integer  "item_type_id"
    t.string   "isDischarged"
    t.text     "dischargeDescription"
  end

  add_index "items", ["item_type_id"], name: "index_items_on_item_type_id"

# Could not dump table "operators" because of following NoMethodError
#   undefined method `[]' for nil:NilClass

  create_table "placements", force: :cascade do |t|
    t.string   "state"
    t.string   "city"
    t.string   "other"
    t.text     "contact"
    t.text     "address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
