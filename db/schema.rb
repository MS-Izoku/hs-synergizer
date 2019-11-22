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

ActiveRecord::Schema.define(version: 2019_11_22_190233) do

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
    t.integer "player_class_id"
  end

  create_table "keywords", force: :cascade do |t|
    t.string "word"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "mechanics", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "player_classes", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tribes", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
