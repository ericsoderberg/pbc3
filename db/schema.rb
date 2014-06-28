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

ActiveRecord::Schema.define(version: 20140524180403) do

  create_table "audios", force: true do |t|
    t.string   "caption"
    t.string   "audio_file_name"
    t.string   "audio_content_type"
    t.integer  "audio_file_size"
    t.datetime "audio_updated_at"
    t.integer  "page_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "date"
    t.string   "verses"
    t.string   "author"
    t.integer  "event_id"
    t.text     "description"
    t.string   "audio2_file_name"
    t.string   "audio2_content_type"
    t.integer  "audio2_file_size"
    t.datetime "audio2_updated_at"
    t.integer  "updated_by"
  end

  create_table "authorizations", force: true do |t|
    t.integer  "page_id"
    t.integer  "user_id"
    t.boolean  "administrator"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "authors", force: true do |t|
    t.string   "name"
    t.string   "url"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", force: true do |t|
    t.text     "text"
    t.integer  "user_id"
    t.integer  "conversation_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contacts", force: true do |t|
    t.integer  "page_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "role"
    t.text     "bio"
    t.string   "portrait_file_name"
    t.string   "portrait_content_type"
    t.integer  "portrait_file_size"
    t.datetime "portrait_updated_at"
  end

  create_table "conversations", force: true do |t|
    t.text     "text"
    t.integer  "user_id"
    t.integer  "page_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "documents", force: true do |t|
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.integer  "page_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.text     "summary"
    t.date     "published_at"
    t.integer  "updated_by"
  end

  create_table "episodes", id: false, force: true do |t|
    t.integer  "id",                       null: false
    t.integer  "podcast_id",               null: false
    t.string   "title",        limit: 128, null: false
    t.string   "speaker",      limit: 128, null: false
    t.text     "description"
    t.string   "path",         limit: 256
    t.date     "publish_date",             null: false
    t.integer  "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "updated_by"
  end

  create_table "event_messages", force: true do |t|
    t.integer  "event_id"
    t.integer  "message_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "event_pages", force: true do |t|
    t.integer  "page_id"
    t.integer  "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", force: true do |t|
    t.string   "name"
    t.datetime "start_at"
    t.datetime "stop_at"
    t.boolean  "all_day"
    t.string   "location"
    t.integer  "page_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "master_id"
    t.boolean  "featured"
    t.text     "invitation_message"
    t.text     "notes"
    t.integer  "updated_by"
    t.string   "global_name"
  end

  create_table "filled_field_options", force: true do |t|
    t.integer  "filled_field_id"
    t.integer  "form_field_option_id"
    t.text     "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "filled_fields", force: true do |t|
    t.integer  "filled_form_id"
    t.integer  "form_field_id"
    t.text     "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "filled_forms", force: true do |t|
    t.integer  "form_id"
    t.integer  "user_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "payment_id"
    t.string   "verification_key"
    t.integer  "version",          default: 1
    t.integer  "parent_id"
  end

  create_table "form_field_options", force: true do |t|
    t.integer  "form_field_id"
    t.integer  "form_field_index"
    t.string   "name"
    t.string   "option_type"
    t.text     "help"
    t.string   "size"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "disabled",         default: false
    t.integer  "value"
  end

  create_table "form_fields", force: true do |t|
    t.integer  "form_id"
    t.integer  "form_index"
    t.string   "name"
    t.string   "field_type"
    t.text     "help"
    t.string   "size"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "required"
    t.boolean  "monetary"
    t.boolean  "dense",           default: false
    t.string   "value"
    t.integer  "form_section_id"
    t.string   "prompt"
    t.integer  "limit"
  end

  create_table "form_sections", force: true do |t|
    t.integer  "form_id"
    t.integer  "form_index"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "forms", force: true do |t|
    t.string   "name"
    t.integer  "page_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "payable"
    t.boolean  "published"
    t.boolean  "pay_by_check"
    t.boolean  "pay_by_paypal"
    t.integer  "updated_by"
    t.integer  "event_id"
    t.integer  "version",             default: 1
    t.integer  "parent_id"
    t.boolean  "authenticated",       default: false
    t.boolean  "many_per_user",       default: false
    t.text     "authentication_text"
  end

  create_table "holidays", force: true do |t|
    t.string   "name"
    t.date     "date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invitations", force: true do |t|
    t.string   "email"
    t.string   "key"
    t.integer  "event_id"
    t.string   "response"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "note"
  end

  create_table "libraries", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "message_descriptions", id: false, force: true do |t|
    t.integer "id"
    t.text    "contents"
  end

  create_table "message_descriptions2", id: false, force: true do |t|
    t.integer "id"
    t.text    "contents"
  end

  create_table "message_files", force: true do |t|
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.integer  "message_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "caption"
    t.string   "vimeo_id"
    t.string   "youtube_id"
  end

  create_table "message_ids", id: false, force: true do |t|
    t.integer "id"
  end

  create_table "message_set_descriptions2", id: false, force: true do |t|
    t.integer "id"
    t.text    "contents"
  end

  create_table "message_set_descriptions3", id: false, force: true do |t|
    t.integer "id"
    t.text    "contents"
  end

  create_table "message_sets", force: true do |t|
    t.string   "title"
    t.string   "url"
    t.text     "description"
    t.integer  "author_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "library_id"
  end

  create_table "messages", force: true do |t|
    t.string   "title"
    t.string   "url"
    t.string   "verses"
    t.datetime "date"
    t.integer  "author_id"
    t.string   "dpid"
    t.text     "description"
    t.integer  "message_set_id"
    t.integer  "message_set_index"
    t.integer  "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "library_id"
    t.integer  "updated_by"
  end

  create_table "newsletters", force: true do |t|
    t.string   "name"
    t.string   "email_list"
    t.date     "published_at"
    t.integer  "featured_page_id"
    t.integer  "featured_event_id"
    t.text     "note"
    t.string   "sent_to"
    t.datetime "sent_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "window",            default: 4, null: false
    t.integer  "updated_by"
  end

  create_table "notes", force: true do |t|
    t.text     "text"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "page_id"
  end

  create_table "pages", force: true do |t|
    t.string   "name"
    t.text     "text"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "url"
    t.text     "hero_text"
    t.boolean  "home_feature",         default: false
    t.integer  "parent_id"
    t.text     "snippet_text"
    t.text     "feature_phrase"
    t.integer  "home_feature_index"
    t.boolean  "private",              default: false
    t.integer  "style_id"
    t.integer  "parent_index"
    t.boolean  "highlightable"
    t.string   "layout",               default: "regular", null: false
    t.string   "email_list"
    t.string   "url_prefix"
    t.boolean  "animate_banner",       default: false
    t.text     "url_aliases"
    t.boolean  "obscure",              default: false
    t.string   "child_layout"
    t.string   "aspect_order"
    t.string   "facebook_url"
    t.string   "twitter_name"
    t.boolean  "feature_upcoming",     default: false
    t.boolean  "allow_for_email_list", default: false
    t.text     "banner_text"
    t.boolean  "parent_feature",       default: false
    t.integer  "parent_feature_index"
    t.boolean  "any_user"
    t.integer  "updated_by"
    t.text     "secondary_text"
    t.boolean  "site_primary",         default: false
  end

  create_table "payments", force: true do |t|
    t.integer  "amount_cents",          default: 0
    t.string   "method"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "received_amount_cents"
    t.datetime "received_at"
    t.integer  "received_by"
    t.text     "received_notes"
    t.text     "notes"
    t.datetime "sent_at"
    t.string   "verification_key"
  end

  create_table "photos", force: true do |t|
    t.string   "caption"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "page_id"
  end

  create_table "podcasts", force: true do |t|
    t.string   "title"
    t.string   "subtitle"
    t.text     "summary"
    t.text     "description"
    t.integer  "user_id"
    t.string   "category"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "page_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "site_id"
    t.string   "sub_category"
  end

  create_table "reservations", force: true do |t|
    t.integer  "event_id"
    t.integer  "resource_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "pre_time"
    t.integer  "post_time"
  end

  create_table "resources", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "resource_type", default: "room"
  end

  create_table "sites", force: true do |t|
    t.integer  "communities_page_id"
    t.integer  "about_page_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
    t.string   "subtitle"
    t.string   "address"
    t.string   "copyright"
    t.string   "email"
    t.string   "mailman_owner"
    t.text     "check_address"
    t.text     "online_bank_vendor"
    t.string   "paypal_business"
    t.text     "phone"
    t.string   "icon_file_name"
    t.string   "icon_content_type"
    t.integer  "icon_file_size"
    t.datetime "icon_updated_at"
    t.string   "acronym"
    t.boolean  "library"
    t.boolean  "calendar",              default: true
    t.string   "wordmark_file_name"
    t.string   "wordmark_content_type"
    t.integer  "wordmark_file_size"
    t.datetime "wordmark_updated_at"
  end

  create_table "styles", force: true do |t|
    t.string   "name"
    t.string   "hero_file_name"
    t.string   "hero_content_type"
    t.integer  "hero_file_size"
    t.datetime "hero_updated_at"
    t.string   "banner_file_name"
    t.string   "banner_content_type"
    t.integer  "banner_file_size"
    t.datetime "banner_updated_at"
    t.string   "feature_strip_file_name"
    t.string   "feature_strip_content_type"
    t.integer  "feature_strip_file_size"
    t.datetime "feature_strip_updated_at"
    t.integer  "feature_color"
    t.integer  "hero_text_color"
    t.text     "css"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "bio_back_file_name"
    t.string   "bio_back_content_type"
    t.integer  "bio_back_file_size"
    t.datetime "bio_back_updated_at"
    t.integer  "bio_back_color",             default: 0
    t.integer  "banner_text_color",          default: 0
    t.string   "child_feature_file_name"
    t.string   "child_feature_content_type"
    t.integer  "child_feature_file_size"
    t.datetime "child_feature_updated_at"
    t.integer  "child_feature_text_color",   default: 0
    t.integer  "updated_by"
  end

  create_table "users", force: true do |t|
    t.string   "email",                              default: "", null: false
    t.string   "encrypted_password",     limit: 128, default: "", null: false
    t.string   "password_salt",                      default: "", null: false
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.boolean  "administrator"
    t.string   "first_name"
    t.string   "last_name"
    t.text     "bio"
    t.string   "portrait_file_name"
    t.string   "portrait_content_type"
    t.integer  "portrait_file_size"
    t.datetime "portrait_updated_at"
    t.string   "name"
    t.string   "email_confirmation"
    t.datetime "reset_password_sent_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "users_videos", force: true do |t|
    t.integer  "user_id"
    t.integer  "video_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "verse_ranges", force: true do |t|
    t.integer  "begin_index"
    t.integer  "end_index"
    t.integer  "message_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "videos", force: true do |t|
    t.string   "caption"
    t.string   "video_file_name"
    t.string   "video_content_type"
    t.integer  "video_file_size"
    t.datetime "video_updated_at"
    t.integer  "page_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "youtube_id"
    t.string   "video2_file_name"
    t.string   "video2_content_type"
    t.integer  "video2_file_size"
    t.datetime "video2_updated_at"
    t.datetime "date"
    t.text     "description"
    t.string   "vimeo_id"
    t.integer  "updated_by"
  end

end
