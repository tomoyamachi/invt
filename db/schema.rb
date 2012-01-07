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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20111022160917) do

  create_table "events", :force => true do |t|
    t.string   "title"
    t.string   "category"
    t.text     "note"
    t.text     "place"
    t.text     "result_date"
    t.integer  "status",                      :default => 0
    t.datetime "dead_line"
    t.integer  "open_flag",                   :default => 0
    t.integer  "host_user_id",   :limit => 8
    t.text     "host_user_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "schedules", :force => true do |t|
    t.integer  "event_id"
    t.string   "proposal_time"
    t.integer  "status",         :default => 0
    t.integer  "rank",           :default => 0
    t.text     "atnd_infos"
    t.text     "not_atnd_infos"
    t.integer  "atnd_num",       :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_events", :force => true do |t|
    t.integer  "user_id",    :limit => 8,                :null => false
    t.text     "user_name"
    t.integer  "event_id",                               :null => false
    t.integer  "status",                  :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "facebook_token"
    t.string   "name"
    t.string   "email"
    t.string   "image_url"
    t.integer  "first_event_id"
    t.integer  "invited_num",    :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
