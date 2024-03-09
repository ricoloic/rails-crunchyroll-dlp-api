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

ActiveRecord::Schema[7.1].define(version: 2024_03_08_062538) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "episode_language_urls", force: :cascade do |t|
    t.bigint "episode_id"
    t.bigint "language_id"
    t.boolean "is_video", null: false
    t.text "url", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["episode_id"], name: "index_episode_language_urls_on_episode_id"
    t.index ["language_id"], name: "index_episode_language_urls_on_language_id"
  end

  create_table "episodes", force: :cascade do |t|
    t.bigint "season_id"
    t.integer "position", null: false
    t.string "title", null: false
    t.text "thumbnail_url"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "subtitles", default: []
    t.index ["season_id"], name: "index_episodes_on_season_id"
  end

  create_table "execution_processes", force: :cascade do |t|
    t.string "status"
    t.string "handle"
    t.text "command_string"
    t.json "output"
    t.datetime "completed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "previous_execution_process_id"
    t.bigint "orchestration_id"
    t.index ["orchestration_id"], name: "index_execution_processes_on_orchestration_id"
    t.index ["previous_execution_process_id"], name: "index_execution_processes_on_previous_execution_process_id"
  end

  create_table "languages", force: :cascade do |t|
    t.string "code", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "orchestrations", force: :cascade do |t|
    t.string "status"
    t.bigint "episode_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "canceled_at"
    t.index ["episode_id"], name: "index_orchestrations_on_episode_id"
  end

  create_table "seasons", force: :cascade do |t|
    t.bigint "show_id"
    t.integer "position", null: false
    t.string "title", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["show_id"], name: "index_seasons_on_show_id"
  end

  create_table "shows", force: :cascade do |t|
    t.string "title", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "episode_language_urls", "episodes"
  add_foreign_key "episode_language_urls", "languages"
  add_foreign_key "episodes", "seasons"
  add_foreign_key "execution_processes", "execution_processes", column: "previous_execution_process_id"
  add_foreign_key "execution_processes", "orchestrations"
  add_foreign_key "orchestrations", "episodes"
  add_foreign_key "seasons", "shows"
end
