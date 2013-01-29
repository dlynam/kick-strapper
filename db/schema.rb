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

ActiveRecord::Schema.define(:version => 20121203003527) do

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "hashed_password",        :limit => 64
    t.string   "username"
    t.string   "referer"
    t.string   "authorization_token"
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
    t.boolean  "enabled",                              :default => true
    t.boolean  "verified_email",                       :default => false
    t.integer  "fb_user_id",             :limit => 8
    t.datetime "created_at"
  end

end
