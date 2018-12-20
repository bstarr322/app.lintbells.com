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

ActiveRecord::Schema.define(version: 2018_12_12_102915) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "access_grants", id: false, force: :cascade do |t|
    t.serial "id", null: false
    t.string "code"
    t.string "access_token"
    t.string "refresh_token"
    t.datetime "access_token_expires_at"
    t.integer "user_id"
    t.integer "client_id"
    t.string "state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "authentications", id: false, force: :cascade do |t|
    t.serial "id", null: false
    t.integer "user_id"
    t.string "provider"
    t.string "uid"
    t.string "oauth_token"
    t.datetime "oauth_expires_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "categories", id: false, force: :cascade do |t|
    t.serial "id", null: false
    t.string "title"
    t.text "description"
    t.integer "order", default: 0
    t.integer "category_id"
    t.string "image_url"
    t.string "number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image"
  end

  create_table "clients", id: false, force: :cascade do |t|
    t.serial "id", null: false
    t.string "app_id"
    t.string "app_secret"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ebooks", id: false, force: :cascade do |t|
    t.serial "id", null: false
    t.string "image"
    t.string "file"
    t.string "author"
    t.string "title"
    t.text "description"
    t.string "ean"
    t.string "isbn"
    t.integer "number_of_pages"
    t.date "publication_date"
    t.string "publisher_name"
    t.string "record_reference"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "events", id: false, force: :cascade do |t|
    t.serial "id", null: false
    t.integer "media_id"
    t.string "title", limit: 55
    t.text "description"
    t.datetime "start_date", precision: 0
    t.datetime "end_date", precision: 0
    t.string "stream_url", limit: 255
    t.integer "product_id"
    t.integer "price"
  end

  create_table "favorite_media", id: false, force: :cascade do |t|
    t.serial "id", null: false
    t.integer "user_id"
    t.string "media_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "gifts", id: false, force: :cascade do |t|
    t.serial "id", null: false
    t.integer "user_id"
    t.string "file", limit: 255
  end

  create_table "lineups", id: false, force: :cascade do |t|
    t.serial "id", null: false
    t.string "l_id"
    t.string "lineup_name"
    t.string "lineup_type"
    t.string "provider_id"
    t.string "provider_name"
    t.string "service_area"
    t.string "country"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "lineups_stations", id: false, force: :cascade do |t|
    t.integer "lineup_id"
    t.integer "station_id"
  end

  create_table "listings", id: false, force: :cascade do |t|
    t.serial "id", null: false
    t.string "s_number"
    t.integer "channel_number"
    t.integer "sub_channel_number"
    t.integer "s_id"
    t.string "callsign"
    t.string "logo_file_name"
    t.datetime "list_date_time"
    t.integer "duration"
    t.integer "show_id"
    t.integer "series_id"
    t.string "show_name"
    t.string "episode_title"
    t.boolean "repeat"
    t.boolean "new"
    t.boolean "live"
    t.boolean "hd"
    t.boolean "descriptive_video"
    t.boolean "in_progress"
    t.string "show_type"
    t.integer "star_rating"
    t.text "description"
    t.string "league"
    t.string "team1"
    t.string "team2"
    t.string "show_picture"
    t.string "web_link"
    t.string "name"
    t.string "station_type"
    t.integer "listing_id"
    t.string "episode_number"
    t.integer "parts"
    t.integer "part_num"
    t.boolean "series_premiere"
    t.boolean "season_premiere"
    t.boolean "series_finale"
    t.boolean "season_finale"
    t.string "rating"
    t.string "guest"
    t.string "director"
    t.string "location"
    t.string "l_id"
    t.datetime "updated_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "media", id: false, force: :cascade do |t|
    t.serial "id", null: false
    t.integer "admin_user_id"
    t.string "title"
    t.text "description"
    t.string "number"
    t.string "image_url"
    t.string "source_url"
    t.text "extra_sources"
    t.string "language"
    t.integer "rating", default: 0
    t.integer "order", default: 0
    t.text "embedded_code"
    t.text "text"
    t.text "overlay_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image"
    t.integer "pricing_plan_id"
    t.boolean "is_a_game", default: false
    t.integer "medium_id"
  end

  create_table "media_categories", id: false, force: :cascade do |t|
    t.serial "id", null: false
    t.integer "medium_id"
    t.integer "category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "order_items", id: false, force: :cascade do |t|
    t.serial "id", null: false
    t.integer "product_id", null: false
    t.integer "order_id", null: false
    t.decimal "price"
    t.string "subscription_unit"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "orders", id: false, force: :cascade do |t|
    t.serial "id", null: false
    t.integer "user_id", null: false
    t.string "mpxid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "payment_details", id: false, force: :cascade do |t|
    t.serial "id", null: false
    t.integer "user_id"
    t.string "card_number"
    t.string "card_type"
    t.string "stripe_customer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "preferences", id: false, force: :cascade do |t|
    t.serial "id", null: false
    t.string "initial_time"
    t.string "station_filter"
    t.integer "time_span"
    t.integer "grid_height"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pricing_plans", id: false, force: :cascade do |t|
    t.serial "id", null: false
    t.string "title"
    t.integer "price", default: 99
    t.string "interval", default: "month"
    t.integer "interval_count", default: 1
    t.integer "trial_period_days", default: 0
    t.string "unique_key"
    t.string "stripe_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "product_items", id: false, force: :cascade do |t|
    t.serial "id", null: false
    t.integer "product_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "item_id"
    t.string "item_type"
  end

  create_table "products", id: false, force: :cascade do |t|
    t.serial "id", null: false
    t.string "mpxid"
    t.string "title"
    t.string "description"
    t.string "images", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.json "pricing_plan"
    t.boolean "available", default: true, null: false
    t.string "image"
    t.integer "pricing_plan_id"
  end

  create_table "roku_codes", id: false, force: :cascade do |t|
    t.serial "id", null: false
    t.string "code", limit: 6
    t.string "device_id", limit: 55
    t.integer "completed", default: 0, null: false
    t.integer "user_id"
    t.string "access_token"
  end

  create_table "shops", force: :cascade do |t|
    t.string "shopify_domain", null: false
    t.string "shopify_token", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["shopify_domain"], name: "index_shops_on_shopify_domain", unique: true
  end

  create_table "stations", id: false, force: :cascade do |t|
    t.serial "id", null: false
    t.string "s_number"
    t.integer "channel_number"
    t.integer "sub_channel_number"
    t.integer "s_id"
    t.string "name"
    t.string "callsign"
    t.string "network"
    t.string "station_type"
    t.integer "ntsc_tsid"
    t.integer "dtv_tsid"
    t.string "twitter"
    t.string "weblink"
    t.string "logo_file_name"
    t.boolean "station_hd"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "subscription_items", id: false, force: :cascade do |t|
    t.serial "id", null: false
    t.integer "subscription_id"
    t.integer "item_id"
    t.string "item_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "subscriptions", id: false, force: :cascade do |t|
    t.serial "id", null: false
    t.integer "user_id"
    t.string "billing_period"
    t.integer "product_id"
    t.string "payment_detail_id"
    t.string "stripe_id"
    t.string "stripe_plan_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "pricing_plan_id"
  end

  create_table "users", id: false, force: :cascade do |t|
    t.serial "id", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "mpx_token"
    t.string "mpx_user_id"
    t.json "billing_address"
    t.string "name"
    t.text "recently_viewed_media_ids", default: [], array: true
    t.string "avatar"
    t.integer "avatar_option", default: 0
    t.string "authentication_token", limit: 30
    t.string "default_language", default: "English"
    t.string "role", default: "user"
    t.datetime "start_trial_date"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "password"
    t.string "password_confirmation"
  end

  create_table "users_stations", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "station_id"
  end

end
