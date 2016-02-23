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

ActiveRecord::Schema.define(version: 20160223123914) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.datetime "synchronized_at"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "card_companies", force: :cascade do |t|
    t.string   "establishment",  limit: 255
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "name",           limit: 255
    t.string   "description",    limit: 255
    t.integer  "responsible_id"
  end

  create_table "contacts", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.string   "last_name",       limit: 255
    t.string   "identifier",      limit: 255
    t.decimal  "amount",                      precision: 8, scale: 2
    t.string   "card_number",     limit: 255
    t.string   "card_type",       limit: 255
    t.string   "card_company",    limit: 255
    t.datetime "created_at",                                                          null: false
    t.datetime "updated_at",                                                          null: false
    t.string   "padma_id",        limit: 255
    t.string   "instructor",      limit: 255
    t.string   "plan",            limit: 255
    t.string   "due_date",        limit: 255
    t.boolean  "payed",                                               default: false
    t.string   "payment",         limit: 255
    t.string   "observations",    limit: 255
    t.string   "bill",            limit: 255
    t.boolean  "active",                                              default: true
    t.boolean  "new_debit",                                           default: true
    t.integer  "card_company_id"
    t.text     "secret"
    t.binary   "secret_key"
    t.binary   "secret_iv"
    t.integer  "account_id"
  end

  create_table "google_users", force: :cascade do |t|
    t.string   "email",           limit: 255
    t.string   "password_digest", limit: 255
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "user_id"
  end

  create_table "presentations", force: :cascade do |t|
    t.integer  "account_id"
    t.integer  "card_company_id"
    t.text     "summary"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "type"
  end

  create_table "responsibles", force: :cascade do |t|
    t.integer  "account_id"
    t.string   "username",   limit: 255
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "name",                   limit: 255
    t.string   "email",                  limit: 255
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
    t.string   "password_digest",        limit: 255
    t.string   "remember_token",         limit: 255
    t.boolean  "admin",                              default: false
    t.integer  "current_account_id"
    t.string   "encrypted_password",     limit: 255, default: "",    null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.string   "username",               limit: 255
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
