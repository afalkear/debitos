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

ActiveRecord::Schema.define(:version => 20131103205621) do

  create_table "alumnos", :force => true do |t|
    t.string   "name"
    t.string   "last_name"
    t.string   "identifier"
    t.decimal  "amount",                         :precision => 8, :scale => 2
    t.binary   "card_number",     :limit => 255
    t.string   "card_type"
    t.string   "card_company"
    t.datetime "created_at",                                                                      :null => false
    t.datetime "updated_at",                                                                      :null => false
    t.string   "padma_id"
    t.string   "instructor"
    t.string   "plan"
    t.string   "due_date"
    t.boolean  "payed",                                                        :default => false
    t.string   "payment"
    t.string   "observations"
    t.string   "bill"
    t.boolean  "active",                                                       :default => true
    t.boolean  "new_debit",                                                    :default => true
    t.integer  "user_id"
    t.binary   "secret"
    t.binary   "secret_key"
    t.binary   "secret_iv"
    t.integer  "card_company_id"
  end

  create_table "card_companies", :force => true do |t|
    t.integer  "user_id"
    t.string   "establishment"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "name"
    t.string   "description"
  end

  create_table "google_users", :force => true do |t|
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.integer  "user_id"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.string   "password_digest"
    t.string   "remember_token"
    t.boolean  "admin",           :default => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

end
