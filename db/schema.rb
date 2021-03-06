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

ActiveRecord::Schema.define(version: 20150420010739) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "notifications", force: true do |t|
    t.integer  "user_id"
    t.boolean  "cleared"
    t.string   "message"
    t.integer  "request_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "notifications", ["user_id"], name: "index_notifications_on_user_id", using: :btree

  create_table "requests", force: true do |t|
    t.integer  "user_id"
    t.datetime "delivery_time"
    t.datetime "completion_time"
    t.integer  "box_quantity"
    t.integer  "driver_id"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "wardrobe_box_quantity"
    t.integer  "bubble_quantity"
    t.integer  "tape_quantity"
    t.string   "driver_name"
    t.text     "driver_notes"
    t.string   "stripe_subscription_identifier"
    t.float    "one_time_payment"
    t.boolean  "tire_request"
    t.text     "proposed_times"
    t.datetime "proposed_date"
    t.float    "delivery_fee"
  end

  add_index "requests", ["user_id"], name: "index_requests_on_user_id", using: :btree

  create_table "storage_items", force: true do |t|
    t.integer  "user_id"
    t.string   "item_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "title"
    t.text     "description"
    t.datetime "entered_storage_at"
    t.datetime "left_storage_at"
    t.integer  "delivery_request_id"
    t.integer  "pickup_request_id"
    t.integer  "user_item_number"
    t.text     "notes"
    t.text     "storage_location"
    t.float    "discount"
    t.integer  "driver_id"
    t.integer  "planned_duration",    default: 1
  end

  add_index "storage_items", ["delivery_request_id"], name: "index_storage_items_on_delivery_request_id", using: :btree
  add_index "storage_items", ["pickup_request_id"], name: "index_storage_items_on_pickup_request_id", using: :btree
  add_index "storage_items", ["user_id"], name: "index_storage_items_on_user_id", using: :btree

  create_table "subscribers", force: true do |t|
    t.string   "email"
    t.string   "zip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  add_index "subscribers", ["email"], name: "index_subscribers_on_email", unique: true, using: :btree

  create_table "unavailable_times", force: true do |t|
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "unavailable_times", ["user_id"], name: "index_unavailable_times_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                               default: "", null: false
    t.string   "encrypted_password",                  default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "address_line_1"
    t.string   "address_line_2"
    t.string   "city"
    t.string   "state"
    t.integer  "zip"
    t.text     "special_instructions"
    t.string   "phone_number"
    t.boolean  "admin"
    t.integer  "storage_item_number",                 default: 1
    t.string   "stripe_customer_identifier"
    t.string   "promo_code"
    t.string   "referrer"
    t.boolean  "terms_of_service_accepted"
    t.string   "name"
    t.boolean  "conversion_tracked"
    t.boolean  "tire_customer"
    t.integer  "estimator_small_item_quantity"
    t.integer  "estimator_medium_item_quantity"
    t.integer  "estimator_large_item_quantity"
    t.integer  "estimator_extra_large_item_quantity"
    t.integer  "estimator_duration"
    t.boolean  "estimator_skip_pickup_request"
    t.boolean  "not_ready"
    t.boolean  "prefers_calls"
    t.boolean  "prefers_texts"
    t.boolean  "prefers_emails"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "version_associations", force: true do |t|
    t.integer "version_id"
    t.string  "foreign_key_name", null: false
    t.integer "foreign_key_id"
  end

  add_index "version_associations", ["foreign_key_name", "foreign_key_id"], name: "index_version_associations_on_foreign_key", using: :btree
  add_index "version_associations", ["version_id"], name: "index_version_associations_on_version_id", using: :btree

  create_table "versions", force: true do |t|
    t.string   "item_type",  null: false
    t.integer  "item_id",    null: false
    t.string   "event",      null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

end
