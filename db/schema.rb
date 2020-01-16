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

ActiveRecord::Schema.define(version: 2020_01_03_011800) do


  create_table "artists", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "card_artists", force: :cascade do |t|
    t.integer "artist_id"
    t.integer "card_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "card_keywords", force: :cascade do |t|
    t.integer "card_id"
    t.integer "keyword_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "card_mechanics", force: :cascade do |t|
    t.integer "card_id"
    t.integer "mechanic_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "cost_change"
  end

  create_table "card_sets", force: :cascade do |t|
    t.string "name"
    t.integer "year"
    t.boolean "standard", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cards", force: :cascade do |t|
    t.string "name"
    t.integer "card_set_id"
    t.integer "player_class_id"
    t.integer "tribe_id"
    t.integer "cost"
    t.integer "health"
    t.integer "attack"
    t.text "card_text"
    t.text "flavor_text"
    t.integer "artist_id"
    t.boolean "elite"
    t.string "img"
    t.string "img_gold"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "dbf_id"
    t.integer "durability"
    t.integer "armor"
    t.boolean "collectable"
    t.integer "dust_cost"
    t.string "rarity"
    t.string "card_type"
  end

  create_table "deck_cards", force: :cascade do |t|
    t.integer "deck_id"
    t.integer "card_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "duplicates"
  end

  create_table "deck_mechanics", force: :cascade do |t|
    t.integer "mechanic_id"
    t.integer "deck_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "decks", force: :cascade do |t|
    t.string "name"
    t.string "deck_code"
    t.integer "creator_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "player_class_id", default: 0
    t.boolean "duplicates"
    t.boolean "standard"
  end

  create_table "keywords", force: :cascade do |t|
    t.string "word"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "mechanics", force: :cascade do |t|
    t.string "name"
    t.string "tribe_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "description"
    t.boolean "is_buff", default: false
  end

  create_table "oauth_access_grants", force: :cascade do |t|
    t.integer "resource_owner_id", null: false
    t.integer "application_id", null: false
    t.string "token", null: false
    t.integer "expires_in", null: false
    t.text "redirect_uri", null: false
    t.datetime "created_at", null: false
    t.datetime "revoked_at"
    t.string "scopes", default: "", null: false
    t.index ["application_id"], name: "index_oauth_access_grants_on_application_id"
    t.index ["resource_owner_id"], name: "index_oauth_access_grants_on_resource_owner_id"
    t.index ["token"], name: "index_oauth_access_grants_on_token", unique: true
  end

  create_table "oauth_access_tokens", force: :cascade do |t|
    t.integer "resource_owner_id"
    t.integer "application_id", null: false
    t.string "token", null: false
    t.string "refresh_token"
    t.integer "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at", null: false
    t.string "scopes"
    t.string "previous_refresh_token", default: "", null: false
    t.index ["application_id"], name: "index_oauth_access_tokens_on_application_id"
    t.index ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true
    t.index ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id"
    t.index ["token"], name: "index_oauth_access_tokens_on_token", unique: true
  end

  create_table "oauth_applications", force: :cascade do |t|
    t.string "name", null: false
    t.string "uid", null: false
    t.string "secret", null: false
    t.text "redirect_uri", null: false
    t.string "scopes", default: "", null: false
    t.boolean "confidential", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["uid"], name: "index_oauth_applications_on_uid", unique: true
  end

  create_table "player_classes", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "dbf_id"
  end

  create_table "saved_decks", force: :cascade do |t|
    t.integer "user_id"
    t.integer "deck_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tribes", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "password_digest"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
