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

ActiveRecord::Schema.define(:version => 20091121173221) do

  create_table "comments", :force => true do |t|
    t.text     "message"
    t.integer  "user_id"
    t.integer  "parent_id"
    t.string   "parent_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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
  end

  create_table "goals", :force => true do |t|
    t.text     "description"
    t.string   "name"
    t.boolean  "propagate",   :default => true
    t.integer  "parent_id"
    t.integer  "map_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "maps", :force => true do |t|
    t.text     "description"
    t.string   "name"
    t.integer  "manager_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "risks", :force => true do |t|
    t.text     "description"
    t.string   "name"
    t.integer  "status",      :default => 2
    t.integer  "goal_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "stakes", :force => true do |t|
    t.string   "name"
    t.boolean  "enforced",   :default => false
    t.integer  "user_id"
    t.integer  "map_id"
    t.integer  "goal_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "supporting_goals", :force => true do |t|
    t.integer  "goal_id"
    t.integer  "supported_by_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email_address"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
