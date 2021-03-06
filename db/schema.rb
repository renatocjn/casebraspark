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

ActiveRecord::Schema.define(version: 20180417184020) do

  create_table "acquisitions", force: :cascade do |t|
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.integer  "supplier_id"
    t.integer  "company_id"
    t.string   "invoice_number"
    t.string   "invoice_id"
    t.string   "invoice_filename"
    t.integer  "invoice_content_size"
    t.string   "invoice_content_type"
    t.integer  "allocation_id"
  end

  add_index "acquisitions", ["allocation_id"], name: "index_acquisitions_on_allocation_id"
  add_index "acquisitions", ["company_id"], name: "index_acquisitions_on_company_id"
  add_index "acquisitions", ["supplier_id"], name: "index_acquisitions_on_supplier_id"

  create_table "allocations", force: :cascade do |t|
    t.text     "reason"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "acquisition_id"
    t.integer  "operator_id"
    t.integer  "destination_id"
    t.integer  "origin_id"
    t.date     "date"
  end

  add_index "allocations", ["acquisition_id"], name: "index_allocations_on_acquisition_id"
  add_index "allocations", ["destination_id"], name: "index_allocations_on_destination_id"
  add_index "allocations", ["operator_id"], name: "index_allocations_on_operator_id"
  add_index "allocations", ["origin_id"], name: "index_allocations_on_origin_id"

  create_table "allocations_items", force: :cascade do |t|
    t.integer "allocation_id"
    t.integer "item_id"
  end

  create_table "companies", force: :cascade do |t|
    t.string   "name"
    t.string   "cnpj"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "computers", force: :cascade do |t|
    t.string "processor"
    t.string "memory"
    t.string "harddrive"
  end

  create_table "dvr_devices", force: :cascade do |t|
    t.integer "number_of_channels"
  end

  create_table "help_devices", force: :cascade do |t|
    t.string "kind"
  end

  create_table "ip_cameras", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ip_phones", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "items", force: :cascade do |t|
    t.string   "plate"
    t.string   "brand"
    t.string   "model"
    t.string   "serial"
    t.float    "value"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.boolean  "isDischarged"
    t.text     "dischargeDescription"
    t.integer  "parkable_item_id"
    t.string   "parkable_item_type"
    t.integer  "placement_id"
  end

  add_index "items", ["placement_id"], name: "index_items_on_placement_id"

  create_table "network_devices", force: :cascade do |t|
    t.string "function"
  end

  create_table "operators", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.boolean  "isAdmin"
    t.boolean  "isBlocked"
  end

  create_table "placements", force: :cascade do |t|
    t.string   "state"
    t.string   "city"
    t.string   "other"
    t.text     "contact"
    t.text     "address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "printers", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "connection"
    t.string   "functions"
    t.string   "paint"
  end

  create_table "screens", force: :cascade do |t|
    t.integer "inches"
  end

  create_table "serviced_items", force: :cascade do |t|
    t.integer  "item_id"
    t.integer  "service_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "serviced_items", ["item_id"], name: "index_serviced_items_on_item_id"
  add_index "serviced_items", ["service_id"], name: "index_serviced_items_on_service_id"

  create_table "services", force: :cascade do |t|
    t.string   "service_type"
    t.text     "description"
    t.float    "value"
    t.string   "invoice_id"
    t.string   "invoice_filename"
    t.string   "invoice_content_size"
    t.string   "invoice_content_type"
    t.date     "send_date"
    t.date     "recv_date"
    t.integer  "supplier_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "services", ["supplier_id"], name: "index_services_on_supplier_id"

  create_table "stabilizers", force: :cascade do |t|
    t.integer  "power"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stock_item_counts", force: :cascade do |t|
    t.integer  "stock_item_id"
    t.integer  "placement_id"
    t.integer  "count"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "stock_item_counts", ["placement_id"], name: "index_stock_item_counts_on_placement_id"
  add_index "stock_item_counts", ["stock_item_id"], name: "index_stock_item_counts_on_stock_item_id"

  create_table "stock_item_groups", force: :cascade do |t|
    t.integer  "stock_item_id"
    t.integer  "quantity"
    t.integer  "allocation_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.float    "unit_value"
  end

  add_index "stock_item_groups", ["allocation_id"], name: "index_stock_item_groups_on_allocation_id"
  add_index "stock_item_groups", ["stock_item_id", "allocation_id"], name: "index_stock_item_groups_on_stock_item_id_and_allocation_id", unique: true
  add_index "stock_item_groups", ["stock_item_id"], name: "index_stock_item_groups_on_stock_item_id"

  create_table "stock_items", force: :cascade do |t|
    t.string   "short_description"
    t.text     "long_description"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "suppliers", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "phones"
    t.string   "other"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "address"
  end

end
