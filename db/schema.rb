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

ActiveRecord::Schema.define(version: 2021_10_24_195311) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
    t.string "email", null: false
    t.string "full_name"
    t.string "uid"
    t.string "avatar_url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
  end

  create_table "events", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "location"
    t.datetime "time"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "created_by"
    t.bigint "updated_by"
  end

  create_table "images", force: :cascade do |t|
    t.string "caption"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "permission_users", force: :cascade do |t|
    t.bigint "user_id_id", null: false
    t.bigint "created_by_id", null: false
    t.bigint "updated_by_id", null: false
    t.bigint "permissions_id_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["created_by_id"], name: "index_permission_users_on_created_by_id"
    t.index ["permissions_id_id"], name: "index_permission_users_on_permissions_id_id"
    t.index ["updated_by_id"], name: "index_permission_users_on_updated_by_id"
    t.index ["user_id_id"], name: "index_permission_users_on_user_id_id"
  end

  create_table "permissions", force: :cascade do |t|
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "players", force: :cascade do |t|
    t.bigint "admin_id", null: false
    t.string "name", null: false
    t.integer "losses", null: false
    t.integer "wins", null: false
    t.text "strengths"
    t.text "weaknesses"
    t.text "additional_info"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["admin_id"], name: "index_players_on_admin_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "events", "admins", column: "created_by", on_delete: :nullify
  add_foreign_key "events", "admins", column: "updated_by", on_delete: :nullify
  add_foreign_key "permission_users", "admins", column: "created_by_id"
  add_foreign_key "permission_users", "admins", column: "updated_by_id"
  add_foreign_key "permission_users", "admins", column: "user_id_id"
  add_foreign_key "permission_users", "permissions", column: "permissions_id_id"
end
