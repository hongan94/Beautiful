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

ActiveRecord::Schema[8.0].define(version: 2026_03_26_173000) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
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

  create_table "activity_logs", force: :cascade do |t|
    t.bigint "user_id"
    t.string "action", null: false
    t.string "trackable_type"
    t.bigint "trackable_id"
    t.jsonb "changes_data", default: {}
    t.string "ip_address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["trackable_type", "trackable_id"], name: "index_activity_logs_on_trackable"
    t.index ["user_id"], name: "index_activity_logs_on_user_id"
  end

  create_table "api_keys", force: :cascade do |t|
    t.string "name", null: false
    t.string "token", null: false
    t.bigint "user_id"
    t.integer "status", default: 0
    t.datetime "expires_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["token"], name: "index_api_keys_on_token", unique: true
    t.index ["user_id"], name: "index_api_keys_on_user_id"
  end

  create_table "article_tags", force: :cascade do |t|
    t.bigint "article_id", null: false
    t.bigint "tag_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["article_id", "tag_id"], name: "index_article_tags_on_article_id_and_tag_id", unique: true
    t.index ["article_id"], name: "index_article_tags_on_article_id"
    t.index ["tag_id"], name: "index_article_tags_on_tag_id"
  end

  create_table "articles", force: :cascade do |t|
    t.string "title", null: false
    t.string "slug", null: false
    t.text "excerpt"
    t.text "content"
    t.integer "status", default: 0
    t.datetime "published_at"
    t.bigint "category_id"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_articles_on_category_id"
    t.index ["slug"], name: "index_articles_on_slug", unique: true
    t.index ["user_id"], name: "index_articles_on_user_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.text "description"
    t.integer "parent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["parent_id"], name: "index_categories_on_parent_id"
    t.index ["slug"], name: "index_categories_on_slug", unique: true
  end

  create_table "chaps", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.bigint "story_id", null: false
    t.integer "status"
    t.string "slug"
    t.integer "view_count", default: 0
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "source"
    t.string "source_slug"
    t.string "source_link"
    t.index ["story_id"], name: "index_chaps_on_story_id"
  end

  create_table "comments", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "story_id", null: false
    t.text "content", null: false
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["status"], name: "index_comments_on_status"
    t.index ["story_id"], name: "index_comments_on_story_id"
    t.index ["user_id", "story_id"], name: "index_comments_on_user_id_and_story_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "crawls", force: :cascade do |t|
    t.string "website"
    t.integer "data_kind"
    t.jsonb "dynamic", default: {}, null: false
    t.integer "pagy_number"
    t.integer "status"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.integer "genre_id"
    t.integer "number_start"
  end

  create_table "favorites", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "story_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["story_id"], name: "index_favorites_on_story_id"
    t.index ["user_id", "story_id"], name: "index_favorites_on_user_id_and_story_id", unique: true
    t.index ["user_id"], name: "index_favorites_on_user_id"
  end

  create_table "media", force: :cascade do |t|
    t.string "name"
    t.string "file_type"
    t.integer "size"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_media_on_user_id"
  end

  create_table "permissions", force: :cascade do |t|
    t.string "action", null: false
    t.string "subject_class", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ratings", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "story_id", null: false
    t.integer "value", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["story_id"], name: "index_ratings_on_story_id"
    t.index ["user_id", "story_id"], name: "index_ratings_on_user_id_and_story_id", unique: true
    t.index ["user_id"], name: "index_ratings_on_user_id"
    t.index ["value"], name: "index_ratings_on_value"
  end

  create_table "seo_meta", force: :cascade do |t|
    t.string "seoable_type", null: false
    t.bigint "seoable_id", null: false
    t.string "meta_title"
    t.text "meta_description"
    t.string "meta_keywords"
    t.string "og_image_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["seoable_type", "seoable_id"], name: "index_seo_meta_on_seoable"
    t.index ["seoable_type", "seoable_id"], name: "index_seo_meta_on_seoable_type_and_seoable_id", unique: true
  end

  create_table "sessions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "ip_address"
    t.string "user_agent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "settings", force: :cascade do |t|
    t.string "key", null: false
    t.jsonb "value", default: {}
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_settings_on_key", unique: true
  end

  create_table "stories", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.bigint "genre_id", null: false
    t.integer "status"
    t.string "slug"
    t.integer "publication_status", default: 0, null: false
    t.string "author"
    t.integer "view_count", default: 0
    t.boolean "is_featured", default: false
    t.string "source"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "source_slug"
    t.string "source_link"
    t.integer "progress_status", default: 0, null: false
    t.boolean "is_hot", default: false
    t.index ["deleted_at"], name: "index_stories_on_deleted_at"
    t.index ["genre_id"], name: "index_stories_on_genre_id"
    t.index ["publication_status"], name: "index_stories_on_publication_status"
    t.index ["slug"], name: "index_stories_on_slug", unique: true
  end

  create_table "story_histories", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "story_id", null: false
    t.bigint "chap_id", null: false
    t.datetime "last_read_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chap_id"], name: "index_story_histories_on_chap_id"
    t.index ["last_read_at"], name: "index_story_histories_on_last_read_at"
    t.index ["story_id"], name: "index_story_histories_on_story_id"
    t.index ["user_id", "story_id"], name: "index_story_histories_on_user_id_and_story_id", unique: true
    t.index ["user_id"], name: "index_story_histories_on_user_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_tags_on_slug", unique: true
  end

  create_table "user_group_permissions", force: :cascade do |t|
    t.bigint "user_group_id", null: false
    t.bigint "permission_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["permission_id"], name: "index_user_group_permissions_on_permission_id"
    t.index ["user_group_id"], name: "index_user_group_permissions_on_user_group_id"
  end

  create_table "user_groups", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "phone_number"
    t.integer "gender"
    t.string "address"
    t.string "avatar"
    t.integer "role"
    t.integer "status"
    t.datetime "last_login_at"
    t.string "last_login_ip"
    t.bigint "user_group_id"
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
    t.index ["user_group_id"], name: "index_users_on_user_group_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "activity_logs", "users"
  add_foreign_key "api_keys", "users"
  add_foreign_key "article_tags", "articles"
  add_foreign_key "article_tags", "tags"
  add_foreign_key "articles", "categories"
  add_foreign_key "articles", "users"
  add_foreign_key "chaps", "stories"
  add_foreign_key "comments", "stories"
  add_foreign_key "comments", "users"
  add_foreign_key "favorites", "stories"
  add_foreign_key "favorites", "users"
  add_foreign_key "media", "users"
  add_foreign_key "ratings", "stories"
  add_foreign_key "ratings", "users"
  add_foreign_key "sessions", "users"
  add_foreign_key "story_histories", "chaps"
  add_foreign_key "story_histories", "stories"
  add_foreign_key "story_histories", "users"
  add_foreign_key "user_group_permissions", "permissions"
  add_foreign_key "user_group_permissions", "user_groups"
  add_foreign_key "users", "user_groups"
end
