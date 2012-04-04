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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120402101359) do

  create_table "printouts", :force => true do |t|
    t.text     "content"
    t.boolean  "printed",    :default => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.integer  "user_id"
  end

  create_table "users", :force => true do |t|
    t.string   "uid"
    t.string   "token"
    t.string   "image"
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
    t.string   "firstname"
    t.string   "surname"
    t.text     "schedule"
    t.datetime "last_scheduled_print_at"
    t.string   "twitter_token"
    t.string   "twitter_secret"
    t.string   "twitter_username"
    t.text     "calendars"
    t.string   "refresh_token"
    t.datetime "expires_at"
    t.boolean  "print_calendar",          :default => true
    t.boolean  "print_email",             :default => true
    t.boolean  "print_qotd",              :default => true
    t.boolean  "print_stories",           :default => true
    t.boolean  "print_twitter_timeline",  :default => false
    t.string   "time_zone",               :default => "UTC"
    t.boolean  "admin",                   :default => false
  end

end
