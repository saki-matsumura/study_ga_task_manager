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

ActiveRecord::Schema.define(version: 2023_12_26_081020) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bookmarks", force: :cascade do |t|
    t.bigint "task_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["task_id"], name: "index_bookmarks_on_task_id"
    t.index ["user_id"], name: "index_bookmarks_on_user_id"
  end

  create_table "clients", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "tasks", force: :cascade do |t|
    t.string "title"
    t.text "note"
    t.date "deadline_on", default: -> { "CURRENT_DATE" }
    t.boolean "done", default: false
    t.string "image"
    t.bigint "client_id"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["client_id"], name: "index_tasks_on_client_id"
    t.index ["user_id"], name: "index_tasks_on_user_id"
  end

  create_table "type_of_tasks", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.string "icon"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "roll", default: 0
  end

  create_table "working_processes", force: :cascade do |t|
    t.bigint "type_of_task_id", null: false
    t.integer "workload"
    t.float "working_hour"
    t.integer "unit"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "task_id", null: false
    t.index ["task_id"], name: "index_working_processes_on_task_id"
    t.index ["type_of_task_id"], name: "index_working_processes_on_type_of_task_id"
  end

  add_foreign_key "bookmarks", "tasks"
  add_foreign_key "bookmarks", "users"
  add_foreign_key "tasks", "clients"
  add_foreign_key "tasks", "users"
  add_foreign_key "working_processes", "tasks"
  add_foreign_key "working_processes", "type_of_tasks"
end
