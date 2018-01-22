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

ActiveRecord::Schema.define(version: 20180122021733) do

  create_table "accesses", force: :cascade do |t|
    t.integer  "spot_id"
    t.text     "name"
    t.text     "type"
    t.text     "start"
    t.text     "arrived"
    t.integer  "total_time"
    t.integer  "total_charge"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["spot_id"], name: "index_accesses_on_spot_id"
  end

  create_table "facilities", force: :cascade do |t|
    t.integer  "spot_id"
    t.text     "name"
    t.text     "quantity"
    t.text     "note"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["spot_id"], name: "index_facilities_on_spot_id"
  end

  create_table "genres", force: :cascade do |t|
    t.text     "name"
    t.integer  "parent_id"
    t.integer  "enable",     default: 1
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "level"
  end

  create_table "parkings", force: :cascade do |t|
    t.integer  "spot_id"
    t.text     "name"
    t.text     "desc"
    t.text     "company"
    t.text     "minutes_to_walk"
    t.integer  "free"
    t.integer  "normal_capacity"
    t.integer  "large_capacity"
    t.integer  "specialize_capacity"
    t.text     "zip"
    t.integer  "prefecture_id"
    t.text     "city"
    t.text     "address1"
    t.text     "address2"
    t.text     "email"
    t.text     "url"
    t.text     "info"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["prefecture_id"], name: "index_parkings_on_prefecture_id"
    t.index ["spot_id"], name: "index_parkings_on_spot_id"
  end

  create_table "prefectures", force: :cascade do |t|
    t.text "name"
    t.text "name_spoken"
  end

  create_table "spot_descriptions", force: :cascade do |t|
    t.integer  "spot_id"
    t.text     "body"
    t.integer  "main",       default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["spot_id"], name: "index_spot_descriptions_on_spot_id"
  end

  create_table "spot_details", force: :cascade do |t|
    t.integer  "spot_id"
    t.text     "sub_name"
    t.text     "sub_name_spoken"
    t.text     "guide_reserve"
    t.integer  "guide_charge"
    t.text     "guide_tel"
    t.text     "guide_fax"
    t.text     "guide_email"
    t.text     "guide_url"
    t.text     "guide_info"
    t.integer  "wifi"
    t.text     "bus_pickup"
    t.text     "bus_frequency"
    t.text     "bus_operation_time"
    t.text     "bus_advance_notice"
    t.integer  "written_us"
    t.integer  "written_ch"
    t.integer  "written_zh"
    t.integer  "written_gr"
    t.integer  "written_fr"
    t.integer  "written_it"
    t.integer  "written_es"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["spot_id"], name: "index_spot_details_on_spot_id"
  end

  create_table "spot_genres", force: :cascade do |t|
    t.integer  "spot_id"
    t.integer  "genre_id"
    t.integer  "main",       default: 0
    t.integer  "level",      default: 1
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["genre_id"], name: "index_spot_genres_on_genre_id"
    t.index ["spot_id", "genre_id"], name: "index_spot_genres_on_spot_id_and_genre_id", unique: true
    t.index ["spot_id"], name: "index_spot_genres_on_spot_id"
  end

  create_table "spot_images", force: :cascade do |t|
    t.integer  "spot_id"
    t.text     "file_name"
    t.text     "url"
    t.text     "copyright"
    t.text     "name"
    t.text     "spoken"
    t.date     "shooting_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["spot_id"], name: "index_spot_images_on_spot_id"
  end

  create_table "spot_terms", force: :cascade do |t|
    t.integer  "spot_id"
    t.integer  "status",      default: 0
    t.text     "season"
    t.date     "open_date"
    t.date     "close_date"
    t.text     "day_of_week"
    t.text     "hour"
    t.text     "info"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["spot_id"], name: "index_spot_terms_on_spot_id"
  end

  create_table "spots", force: :cascade do |t|
    t.integer  "genre_id"
    t.text     "name"
    t.text     "name_spoken"
    t.text     "body"
    t.decimal  "longitude",           precision: 10, scale: 7
    t.decimal  "latitude",            precision: 10, scale: 7
    t.text     "zip"
    t.integer  "prefecture_id"
    t.text     "city"
    t.text     "address1"
    t.text     "address2"
    t.text     "tel"
    t.text     "fax"
    t.text     "email"
    t.text     "url"
    t.text     "active_term"
    t.text     "image_url"
    t.text     "image_copyright"
    t.text     "image_name"
    t.text     "image_spoken"
    t.text     "image_shooting_date"
    t.text     "ref_city_code"
    t.text     "ref_name"
    t.text     "ref_id"
    t.text     "ref_sub_id"
    t.date     "ref_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["genre_id"], name: "index_spots_on_genre_id"
    t.index ["prefecture_id"], name: "index_spots_on_prefecture_id"
  end

end
