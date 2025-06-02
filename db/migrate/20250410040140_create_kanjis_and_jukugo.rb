class CreateKanjisAndJukugo < ActiveRecord::Migration[8.0]
  def change
    create_table :kanjis, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
      t.string :character, null: false  # 漢字そのもの
      t.string :reading_on           # 音読み（複数ある場合はカンマ区切り）
      t.string :reading_kun          # 訓読み（複数ある場合はカンマ区切り）
      t.text :meaning               # 意味
      t.string :grade                # 級（漢検一級、準一級など）
      t.integer :stroke_count        # 画数
      t.text :example_words         # 例語
      t.text :example_sentences     # 例文
      t.string :radical              # 部首
      t.timestamps
    end

    add_index :kanjis, :character, unique: true
    add_index :kanjis, :grade

    create_table :jukugos, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
      t.string :expression, null: false  # 四字熟語や熟語
      t.string :reading               # 読み方
      t.string :reading_alphabet     # 読み方(タイピング用)
      t.text :meaning                # 意味
      t.string :difficulty           # 難易度（漢検一級相当など）
      t.text :example_sentences      # 例文
      t.timestamps
    end

    add_index :jukugos, :expression, unique: true
    add_index :jukugos, :difficulty

    # 漢字とタグの関連付け
    create_table :kanji_tags, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
      t.bigint :kanji_id, null: false
      t.bigint :tag_id, null: false
      t.timestamps
    end

    add_index :kanji_tags, [ :kanji_id, :tag_id ], unique: true
    add_index :kanji_tags, :tag_id

    create_table :jukugo_tags, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
      t.bigint :jukugo_id, null: false
      t.bigint :tag_id, null: false
      t.timestamps
    end

    add_index :jukugo_tags, [ :jukugo_id, :tag_id ], unique: true
    add_index :jukugo_tags, :tag_id
  end
end
