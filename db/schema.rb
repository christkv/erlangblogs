# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090429143441) do

  create_table "blog_entries", :force => true do |t|
    t.integer  "blog_id",        :null => false
    t.string   "title",          :null => false
    t.text     "content",        :null => false
    t.text     "url",            :null => false
    t.datetime "date_published", :null => false
    t.text     "metadata"
    t.string   "hash_value",     :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "blogs", :force => true do |t|
    t.integer  "user_id",      :null => false
    t.string   "title",        :null => false
    t.text     "description",  :null => false
    t.text     "url",          :null => false
    t.text     "feed_url",     :null => false
    t.datetime "last_updated", :null => false
    t.text     "metadata"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "channels", :force => true do |t|
    t.string   "title",       :null => false
    t.text     "description"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "channels_blogs", :force => true do |t|
    t.integer  "channel_id", :null => false
    t.integer  "blog_id",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "facebook_templates", :force => true do |t|
    t.string "template_name", :null => false
    t.string "content_hash",  :null => false
    t.string "bundle_id"
  end

  add_index "facebook_templates", ["template_name"], :name => "index_facebook_templates_on_template_name", :unique => true

  create_table "invites", :force => true do |t|
    t.integer  "user_id",        :null => false
    t.integer  "user_id_target", :null => false
    t.text     "message"
    t.boolean  "is_accepted"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "open_id_authentication_associations", :force => true do |t|
    t.integer "issued"
    t.integer "lifetime"
    t.string  "handle"
    t.string  "assoc_type"
    t.binary  "server_url"
    t.binary  "secret"
  end

  create_table "open_id_authentication_nonces", :force => true do |t|
    t.integer "timestamp",  :null => false
    t.string  "server_url"
    t.string  "salt",       :null => false
  end

  create_table "project_downloads", :force => true do |t|
    t.integer  "project_id", :null => false
    t.datetime "updated_at"
    t.string   "author"
    t.text     "title"
    t.text     "url"
    t.string   "hash_value", :null => false
    t.datetime "created_at"
  end

  create_table "project_follows", :force => true do |t|
    t.integer  "project_id", :null => false
    t.integer  "user_id",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "project_updates", :force => true do |t|
    t.integer  "project_id", :null => false
    t.datetime "updated_at"
    t.string   "author"
    t.text     "title"
    t.text     "url"
    t.string   "hash_value", :null => false
    t.datetime "created_at"
  end

  create_table "projects", :force => true do |t|
    t.string   "site",        :null => false
    t.text     "url",         :null => false
    t.text     "title"
    t.text     "description"
    t.string   "hash_value",  :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "metadata"
  end

  create_table "user_platforms", :force => true do |t|
    t.string   "login",      :null => false
    t.string   "platform"
    t.string   "auth_token"
    t.string   "session"
    t.string   "email"
    t.text     "metadata"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_projects", :force => true do |t|
    t.integer  "project_id", :null => false
    t.integer  "user_id",    :null => false
    t.string   "role",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "firstname",                                           :null => false
    t.string   "lastname",                                            :null => false
    t.string   "email",                                               :null => false
    t.string   "login"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token",                                   :null => false
    t.string   "single_access_token",                                 :null => false
    t.string   "perishable_token",                                    :null => false
    t.integer  "login_count",                      :default => 0,     :null => false
    t.integer  "failed_login_count",               :default => 0,     :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "openid_identifier"
    t.boolean  "active",                           :default => false
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.integer  "fb_user_id",          :limit => 8
    t.string   "email_hash"
    t.string   "name"
  end

  add_index "users", ["openid_identifier"], :name => "index_users_on_openid_identifier"

end
