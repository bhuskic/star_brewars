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

ActiveRecord::Schema.define(version: 20151218115655) do

  create_table "groceries", force: :cascade do |t|
    t.string   "name"
    t.string   "grocery_type"
    t.text     "characteristics"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "ingredients", force: :cascade do |t|
    t.string   "amount"
    t.integer  "grocery_id"
    t.integer  "recipe_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "ingredients", ["grocery_id"], name: "index_ingredients_on_grocery_id"
  add_index "ingredients", ["recipe_id"], name: "index_ingredients_on_recipe_id"

  create_table "recipes", force: :cascade do |t|
    t.string   "name"
    t.string   "beer_style"
    t.string   "beer_type"
    t.text     "procedure_description"
    t.integer  "user_id"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "recipes", ["user_id"], name: "index_recipes_on_user_id"

  create_table "role_permissions", force: :cascade do |t|
    t.string   "name"
    t.string   "policy_name"
    t.string   "policy_scope"
    t.integer  "role_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "role_permissions", ["role_id"], name: "index_role_permissions_on_role_id"

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.string   "display_name"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "roles_users", id: false, force: :cascade do |t|
    t.integer "role_id", null: false
    t.integer "user_id", null: false
  end

  add_index "roles_users", ["role_id"], name: "index_roles_users_on_role_id"
  add_index "roles_users", ["user_id"], name: "index_roles_users_on_user_id"

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "auth_token"
  end

end
