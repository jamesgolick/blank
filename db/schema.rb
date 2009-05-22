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

ActiveRecord::Schema.define(:version => 20081019180856) do

  create_table "open_id_authentication_associations", :force => true do |t|
    t.integer "issued"
    t.integer "lifetime"
    t.string  "handle"
    t.string  "assoc_type"
    t.binary  "server_url"
    t.binary  "secret"
  end

  create_table "open_id_authentication_nonces", :force => true do |t|
    t.integer "timestamp",  :null => false
    t.string  "server_url"
    t.string  "salt",       :null => false
  end

  create_table "people", :force => true do |t|
    t.string   "name",                        :limit => 100, :default => ""
    t.string   "email",                       :limit => 100
    t.string   "crypted_password",            :limit => 40
    t.string   "salt",                        :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token",              :limit => 40
    t.datetime "remember_token_expires_at"
    t.string   "password_reset_code"
    t.datetime "password_reset_code_expires"
    t.string   "open_id_url"
  end

  add_index "people", ["email"], :name => "index_people_on_email", :unique => true
  add_index "people", ["open_id_url"], :name => "index_people_on_open_id_url", :unique => true

end
