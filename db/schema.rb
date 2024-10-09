# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2024_10_09_141523) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource"
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "addresses", force: :cascade do |t|
    t.bigint "listing_id", null: false
    t.string "country"
    t.string "city"
    t.string "street"
    t.string "locator"
    t.string "postal_code"
    t.string "postal_town"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["listing_id"], name: "index_addresses_on_listing_id"
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "administrators", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_administrators_on_email", unique: true
    t.index ["reset_password_token"], name: "index_administrators_on_reset_password_token", unique: true
  end

  create_table "advertiser_contacts", force: :cascade do |t|
    t.string "company_name"
    t.string "org_number"
    t.string "first_name"
    t.string "last_name"
    t.string "phone"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "amenities", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_amenities_on_deleted_at"
  end

  create_table "blog_posts", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.text "excerpt"
    t.string "meta_description"
    t.boolean "visible"
    t.boolean "top_story"
    t.bigint "category_id", null: false
    t.bigint "admin_user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.index ["admin_user_id"], name: "index_blog_posts_on_admin_user_id"
    t.index ["category_id"], name: "index_blog_posts_on_category_id"
    t.index ["slug"], name: "index_blog_posts_on_slug", unique: true
  end

  create_table "brands", force: :cascade do |t|
    t.string "name"
    t.bigint "provider_id", null: false
    t.text "description"
    t.boolean "is_featured"
    t.string "slug"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "active", default: false
    t.text "extended_description"
    t.bigint "header_image_id"
    t.bigint "logo_id"
    t.index ["deleted_at"], name: "index_brands_on_deleted_at"
    t.index ["header_image_id"], name: "index_brands_on_header_image_id"
    t.index ["logo_id"], name: "index_brands_on_logo_id"
    t.index ["provider_id"], name: "index_brands_on_provider_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "active", default: false
    t.text "svg_content"
    t.index ["slug"], name: "index_categories_on_slug", unique: true
  end

  create_table "external_listings", force: :cascade do |t|
    t.bigint "listing_id", null: false
    t.string "external_id"
    t.string "source_url"
    t.json "additional_data"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_external_listings_on_deleted_at"
    t.index ["listing_id"], name: "index_external_listings_on_listing_id"
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_type", "sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_type_and_sluggable_id"
  end

  create_table "geojsons", force: :cascade do |t|
    t.bigint "listing_id", null: false
    t.float "coordinates"
    t.string "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["listing_id"], name: "index_geojsons_on_listing_id"
  end

  create_table "images", force: :cascade do |t|
    t.string "alt_text"
    t.bigint "blog_post_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["blog_post_id"], name: "index_images_on_blog_post_id"
  end

  create_table "listing_amenities", force: :cascade do |t|
    t.bigint "listing_id", null: false
    t.bigint "amenity_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["amenity_id"], name: "index_listing_amenities_on_amenity_id"
    t.index ["listing_id"], name: "index_listing_amenities_on_listing_id"
  end

  create_table "listing_users", force: :cascade do |t|
    t.bigint "listing_id", null: false
    t.bigint "provider_user_id", null: false
    t.string "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["listing_id"], name: "index_listing_users_on_listing_id"
    t.index ["provider_user_id"], name: "index_listing_users_on_provider_user_id"
  end

  create_table "listings", force: :cascade do |t|
    t.bigint "brand_id", null: false
    t.integer "size"
    t.float "cost_per_m2"
    t.float "cost_per_user"
    t.float "surface_per_user"
    t.text "description"
    t.text "description_en"
    t.integer "number_of_meeting_rooms"
    t.date "opened"
    t.boolean "is_premium_listing"
    t.string "conference_room_request_email"
    t.string "name"
    t.string "short_description"
    t.string "short_description_en"
    t.string "url"
    t.string "showing_message"
    t.integer "status"
    t.integer "source"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.text "area_description"
    t.text "commuter_description"
    t.index ["brand_id"], name: "index_listings_on_brand_id"
    t.index ["deleted_at"], name: "index_listings_on_deleted_at"
    t.index ["slug"], name: "index_listings_on_slug", unique: true
  end

  create_table "locations", force: :cascade do |t|
    t.string "name"
    t.json "geojson"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "prioritized", default: false
    t.string "preposition"
    t.index ["slug"], name: "index_locations_on_slug", unique: true
  end

  create_table "locations_search_contacts", id: false, force: :cascade do |t|
    t.bigint "search_contact_id", null: false
    t.bigint "location_id", null: false
    t.index ["location_id", "search_contact_id"], name: "index_locations_search_contacts"
    t.index ["search_contact_id", "location_id"], name: "index_search_contacts_locations"
  end

  create_table "offer_excluded_amenities", force: :cascade do |t|
    t.bigint "offer_id", null: false
    t.bigint "amenity_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["amenity_id"], name: "index_offer_excluded_amenities_on_amenity_id"
    t.index ["offer_id"], name: "index_offer_excluded_amenities_on_offer_id"
  end

  create_table "offer_paid_amenities", force: :cascade do |t|
    t.bigint "offer_id", null: false
    t.bigint "amenity_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["amenity_id"], name: "index_offer_paid_amenities_on_amenity_id"
    t.index ["offer_id"], name: "index_offer_paid_amenities_on_offer_id"
  end

  create_table "offer_versions", force: :cascade do |t|
    t.bigint "offer_id", null: false
    t.integer "version_number"
    t.json "offer_changes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["offer_id"], name: "index_offer_versions_on_offer_id"
  end

  create_table "offers", force: :cascade do |t|
    t.bigint "listing_id", null: false
    t.string "name"
    t.text "description"
    t.text "description_en"
    t.float "price"
    t.string "desk_type"
    t.integer "nb_days"
    t.boolean "personal"
    t.float "area"
    t.integer "max_seats"
    t.integer "min_seats"
    t.json "terms"
    t.integer "status"
    t.integer "offer_type"
    t.integer "category"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_offers_on_deleted_at"
    t.index ["listing_id"], name: "index_offers_on_listing_id"
  end

  create_table "office_calculations", force: :cascade do |t|
    t.jsonb "steps_data", default: {}, null: false
    t.bigint "location_id", null: false
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "company", null: false
    t.string "email", null: false
    t.string "phone", null: false
    t.boolean "terms_acceptance", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["location_id"], name: "index_office_calculations_on_location_id"
    t.index ["steps_data"], name: "index_office_calculations_on_steps_data", using: :gin
  end

  create_table "permutations", force: :cascade do |t|
    t.bigint "location_id", null: false
    t.bigint "premise_type_id", null: false
    t.text "custom_data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "introduction"
    t.text "in_depth_description"
    t.text "commuter_description"
    t.index ["location_id"], name: "index_permutations_on_location_id"
    t.index ["premise_type_id"], name: "index_permutations_on_premise_type_id"
  end

  create_table "premise_types", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_premise_types_on_slug", unique: true
  end

  create_table "provider_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role"
    t.string "first_name"
    t.string "last_name"
    t.string "mobile_phone"
    t.bigint "provider_id"
    t.string "magic_token"
    t.datetime "magic_token_expires_at"
    t.datetime "magic_token_consumed_at"
    t.index ["deleted_at"], name: "index_provider_users_on_deleted_at"
    t.index ["email"], name: "index_provider_users_on_email", unique: true
    t.index ["magic_token"], name: "index_provider_users_on_magic_token", unique: true
    t.index ["provider_id"], name: "index_provider_users_on_provider_id"
    t.index ["reset_password_token"], name: "index_provider_users_on_reset_password_token", unique: true
  end

  create_table "providers", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "ovid"
    t.string "postal_code"
    t.string "city"
    t.text "invoice_notes"
    t.string "organizational_number"
    t.string "street"
    t.string "invoice_email"
    t.string "woid"
    t.string "website"
    t.string "contact_email"
    t.index ["deleted_at"], name: "index_providers_on_deleted_at"
  end

  create_table "rooms", force: :cascade do |t|
    t.bigint "listing_id", null: false
    t.integer "size"
    t.integer "workspaces"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["listing_id"], name: "index_rooms_on_listing_id"
  end

  create_table "search_contacts", force: :cascade do |t|
    t.string "company_name"
    t.string "first_name"
    t.string "last_name"
    t.string "phone"
    t.string "email"
    t.integer "number_of_workspaces"
    t.string "office_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "solution_rooms", force: :cascade do |t|
    t.bigint "solution_id", null: false
    t.bigint "room_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["room_id"], name: "index_solution_rooms_on_room_id"
    t.index ["solution_id"], name: "index_solution_rooms_on_solution_id"
  end

  create_table "solutions", force: :cascade do |t|
    t.bigint "listing_id", null: false
    t.integer "size"
    t.integer "workspaces"
    t.float "price"
    t.float "original_price"
    t.text "description"
    t.boolean "is_big_office"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_solutions_on_deleted_at"
    t.index ["listing_id"], name: "index_solutions_on_listing_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "addresses", "listings"
  add_foreign_key "blog_posts", "admin_users"
  add_foreign_key "blog_posts", "categories"
  add_foreign_key "brands", "active_storage_blobs", column: "header_image_id"
  add_foreign_key "brands", "active_storage_blobs", column: "logo_id"
  add_foreign_key "brands", "providers"
  add_foreign_key "external_listings", "listings"
  add_foreign_key "geojsons", "listings"
  add_foreign_key "images", "blog_posts"
  add_foreign_key "listing_amenities", "amenities"
  add_foreign_key "listing_amenities", "listings"
  add_foreign_key "listing_users", "listings"
  add_foreign_key "listing_users", "provider_users"
  add_foreign_key "listings", "brands"
  add_foreign_key "offer_excluded_amenities", "amenities"
  add_foreign_key "offer_excluded_amenities", "offers"
  add_foreign_key "offer_paid_amenities", "amenities"
  add_foreign_key "offer_paid_amenities", "offers"
  add_foreign_key "offer_versions", "offers"
  add_foreign_key "offers", "listings"
  add_foreign_key "office_calculations", "locations"
  add_foreign_key "permutations", "locations"
  add_foreign_key "permutations", "premise_types"
  add_foreign_key "provider_users", "providers"
  add_foreign_key "rooms", "listings"
  add_foreign_key "solution_rooms", "rooms"
  add_foreign_key "solution_rooms", "solutions"
  add_foreign_key "solutions", "listings"
end
