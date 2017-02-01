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

ActiveRecord::Schema.define(version: 20170130021449) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "games", force: true do |t|
    t.string   "name"
    t.integer  "white_player_id"
    t.integer  "black_player_id"
    t.string   "result"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "games", ["black_player_id"], name: "index_games_on_black_player_id", using: :btree
  add_index "games", ["white_player_id"], name: "index_games_on_white_player_id", using: :btree

  create_table "moves", force: true do |t|
    t.integer  "game_id"
    t.boolean  "is_black"
    t.integer  "time_sec_lapse"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "piece_id"
    t.integer  "start_row"
    t.integer  "start_column"
    t.integer  "end_row"
    t.integer  "end_column"
  end

  add_index "moves", ["game_id"], name: "index_moves_on_game_id", using: :btree

  create_table "pieces", force: true do |t|
    t.integer  "game_id"
    t.string   "type"
    t.integer  "row"
    t.integer  "column"
    t.boolean  "is_black"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_selected"
    t.boolean  "captured"
  end

  add_index "pieces", ["game_id"], name: "index_pieces_on_game_id", using: :btree

  create_table "players", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "players", ["email"], name: "index_players_on_email", unique: true, using: :btree
  add_index "players", ["reset_password_token"], name: "index_players_on_reset_password_token", unique: true, using: :btree

end
