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

ActiveRecord::Schema.define(version: 20140103052206) do

  create_table "games", force: true do |t|
    t.string   "name",            null: false
    t.string   "permalink",       null: false
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "details_columns"
  end

  add_index "games", ["permalink"], name: "index_games_on_permalink", unique: true
  add_index "games", ["user_id"], name: "index_games_on_user_id"

  create_table "players", force: true do |t|
    t.string   "details"
    t.integer  "kills",      default: 0
    t.boolean  "is_alive",   default: true
    t.integer  "hunter_id"
    t.integer  "game_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "last_name"
    t.string   "first_name"
  end

  add_index "players", ["game_id"], name: "index_players_on_game_id"
  add_index "players", ["hunter_id"], name: "index_players_on_hunter_id"
  add_index "players", ["last_name"], name: "index_players_on_last_name"

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email",           null: false
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["remember_token"], name: "index_users_on_remember_token"

end
