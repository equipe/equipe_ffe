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

ActiveRecord::Schema.define(version: 20160914172420) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "clubs", force: :cascade do |t|
    t.string   "ffe_id"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ffe_id"], name: "index_clubs_on_ffe_id", using: :btree
  end

  create_table "competitions", force: :cascade do |t|
    t.integer  "show_id"
    t.date     "starts_on",                    null: false
    t.string   "competition_no"
    t.string   "name"
    t.string   "discipline"
    t.string   "judgement_id"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "late_entry_fee"
    t.string   "horse_pony",     default: "R", null: false
    t.integer  "profil_detail"
    t.index ["show_id"], name: "index_competitions_on_show_id", using: :btree
  end

  create_table "entries", force: :cascade do |t|
    t.string   "ffe_id",         null: false
    t.integer  "competition_id"
    t.integer  "start_no"
    t.integer  "rider_id"
    t.integer  "horse_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["competition_id"], name: "index_entries_on_competition_id", using: :btree
    t.index ["ffe_id"], name: "index_entries_on_ffe_id", using: :btree
    t.index ["horse_id"], name: "index_entries_on_horse_id", using: :btree
    t.index ["rider_id"], name: "index_entries_on_rider_id", using: :btree
  end

  create_table "horses", force: :cascade do |t|
    t.string   "licence"
    t.string   "chip_no"
    t.string   "name"
    t.string   "sire"
    t.string   "dam"
    t.string   "dam_sire"
    t.integer  "born_year"
    t.string   "color"
    t.string   "breed"
    t.string   "race"
    t.integer  "height"
    t.string   "sex"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "category",   default: "H", null: false
    t.index ["licence"], name: "index_horses_on_licence", using: :btree
  end

  create_table "organizers", force: :cascade do |t|
    t.string   "ffe_id"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ffe_id"], name: "index_organizers_on_ffe_id", using: :btree
  end

  create_table "people", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "licence"
    t.date     "birthday"
    t.boolean  "official",   default: false, null: false
    t.integer  "club_id"
    t.integer  "region_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.index ["club_id"], name: "index_people_on_club_id", using: :btree
    t.index ["licence"], name: "index_people_on_licence", using: :btree
    t.index ["region_id"], name: "index_people_on_region_id", using: :btree
  end

  create_table "regions", force: :cascade do |t|
    t.string   "ffe_id"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ffe_id"], name: "index_regions_on_ffe_id", using: :btree
  end

  create_table "shows", force: :cascade do |t|
    t.integer  "organizer_id"
    t.string   "ffe_id"
    t.string   "name"
    t.date     "starts_on"
    t.date     "ends_on"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["ffe_id"], name: "index_shows_on_ffe_id", using: :btree
    t.index ["organizer_id"], name: "index_shows_on_organizer_id", using: :btree
  end

  add_foreign_key "competitions", "shows"
  add_foreign_key "entries", "competitions"
  add_foreign_key "entries", "horses"
  add_foreign_key "entries", "people", column: "rider_id"
  add_foreign_key "people", "clubs"
  add_foreign_key "people", "regions"
  add_foreign_key "shows", "organizers"
end
