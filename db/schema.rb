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

ActiveRecord::Schema[8.0].define(version: 2025_06_02_021513) do
  create_table "jukugo_tags", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "jukugo_id", null: false
    t.bigint "tag_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["jukugo_id", "tag_id"], name: "index_jukugo_tags_on_jukugo_id_and_tag_id", unique: true
    t.index ["tag_id"], name: "index_jukugo_tags_on_tag_id"
  end

  create_table "jukugos", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "expression", null: false
    t.string "reading"
    t.string "reading_alphabet"
    t.text "meaning"
    t.string "difficulty"
    t.text "example_sentences"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["difficulty"], name: "index_jukugos_on_difficulty"
    t.index ["expression"], name: "index_jukugos_on_expression", unique: true
  end

  create_table "kanji_tags", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "kanji_id", null: false
    t.bigint "tag_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["kanji_id", "tag_id"], name: "index_kanji_tags_on_kanji_id_and_tag_id", unique: true
    t.index ["tag_id"], name: "index_kanji_tags_on_tag_id"
  end

  create_table "kanjis", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "character", null: false
    t.string "reading_on"
    t.string "reading_kun"
    t.text "meaning"
    t.string "grade"
    t.integer "stroke_count"
    t.text "example_words"
    t.text "example_sentences"
    t.string "radical"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["character"], name: "index_kanjis_on_character", unique: true
    t.index ["grade"], name: "index_kanjis_on_grade"
  end

  create_table "quote_tags", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "quote_id", null: false
    t.bigint "tag_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["quote_id"], name: "index_quote_tags_on_quote_id"
    t.index ["tag_id"], name: "index_quote_tags_on_tag_id"
  end

  create_table "quotes", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.text "content"
    t.text "content_alphabet"
    t.string "source"
    t.string "author"
    t.string "work"
    t.string "era"
    t.string "tags"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "scores", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "user_name"
    t.string "score_type"
    t.float "wpm"
    t.float "accuracy"
    t.float "time_taken"
    t.datetime "completed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tags", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "quote_tags", "quotes"
  add_foreign_key "quote_tags", "tags"
end
