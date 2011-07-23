# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110723154051) do

  create_table "comments", :force => true do |t|
    t.text     "message"
    t.integer  "user_id"
    t.integer  "parent_id"
    t.string   "parent_type"
    t.integer  "status"
    t.boolean  "override_status", :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  create_table "events", :force => true do |t|
    t.string   "action"
    t.integer  "user_id"
    t.string   "subdomain"
    t.integer  "model_id"
    t.string   "model_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "events", ["subdomain"], :name => "index_events_on_subdomain"

  create_table "factors", :force => true do |t|
    t.text     "description"
    t.string   "name"
    t.string   "target"
    t.string   "report"
    t.string   "fail"
    t.string   "likely"
    t.string   "best"
    t.string   "worst"
    t.integer  "goal_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "priority",         :default => "medium"
    t.string   "benchmark"
    t.string   "benchmark_source"
    t.datetime "deleted_at"
  end

  create_table "goals", :force => true do |t|
    t.text     "description"
    t.string   "name"
    t.boolean  "propagate",   :default => true
    t.integer  "parent_id"
    t.integer  "map_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  create_table "maps", :force => true do |t|
    t.text     "description"
    t.string   "name"
    t.integer  "manager_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "subdomain"
    t.datetime "deleted_at"
  end

  add_index "maps", ["subdomain"], :name => "index_maps_on_subdomain"

  create_table "risks", :force => true do |t|
    t.text     "description"
    t.string   "name"
    t.integer  "status",      :default => 2
    t.integer  "goal_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  create_table "stakes", :force => true do |t|
    t.string   "name"
    t.boolean  "enforced",   :default => false
    t.integer  "user_id"
    t.integer  "map_id"
    t.integer  "goal_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  create_table "supporting_goals", :force => true do |t|
    t.integer  "goal_id"
    t.integer  "supported_by_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.boolean  "admin",                               :default => false
    t.string   "email",                               :default => "",    :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "",    :null => false
    t.string   "password_salt",                       :default => "",    :null => false
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "subdomain"
    t.datetime "deleted_at"
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["subdomain"], :name => "index_users_on_subdomain"

end
