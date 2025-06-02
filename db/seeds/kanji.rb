tags = {
  "動物" => Tag.find_or_create_by!(name: "動物"),
  "自然" => Tag.find_or_create_by!(name: "自然"),
  "感情" => Tag.find_or_create_by!(name: "感情"),
  "行動" => Tag.find_or_create_by!(name: "行動"),
  "思想" => Tag.find_or_create_by!(name: "思想"),
  "漢検1級" => Tag.find_or_create_by!(name: "漢検1級"),
  "難読" => Tag.find_or_create_by!(name: "難読")
}

# 漢字のサンプルデータ
kanjis_data = [
  {
    character: "憂",
    reading_on: "ユウ",
    reading_kun: "うれ.える、うれ.い、う.い、う.き",
    meaning: "憂い、心配する、悲しむ",
    grade: "漢検1級",
    stroke_count: 15,
    example_words: "憂鬱、憂患、憂色",
    example_sentences: "彼は国の将来を憂えている。",
    radical: "心",
    tags: [ "感情", "漢検1級" ]
  },
  {
    character: "蜿",
    reading_on: "エン",
    reading_kun: "はうきょ",
    meaning: "曲がりくねっている様子",
    grade: "漢検1級",
    stroke_count: 14,
    example_words: "蜿蜒、蜿転",
    example_sentences: "蜿蜒と続く山道を登った。",
    radical: "虫",
    tags: [ "自然", "漢検1級", "難読" ]
  },
  {
    character: "斡",
    reading_on: "アツ、カン",
    reading_kun: "めぐ.る、とりもち",
    meaning: "物事を取り持つこと、周る",
    grade: "漢検1級",
    stroke_count: 14,
    example_words: "斡旋、周斡",
    example_sentences: "彼は交渉を斡旋した。",
    radical: "斗",
    tags: [ "行動", "漢検1級" ]
  },
  {
    character: "鬱",
    reading_on: "ウツ",
    reading_kun: "うっ.する、ふさ.ぐ",
    meaning: "ふさがる、こもる、茂る、塞ぐ、沈む気持ち",
    grade: "漢検1級",
    stroke_count: 29,
    example_words: "鬱病、鬱積、鬱憤",
    example_sentences: "鬱蒼とした森の中を歩いた。",
    radical: "鬯",
    tags: [ "感情", "自然", "漢検1級" ]
  },
  {
    character: "諄",
    reading_on: "シュン、ジュン",
    reading_kun: "くど.い、ねんご.ろ",
    meaning: "くどい、念入りに繰り返し教える",
    grade: "漢検1級",
    stroke_count: 15,
    example_words: "諄諄、諄々",
    example_sentences: "彼は諄々と道理を説いた。",
    radical: "言",
    tags: [ "行動", "漢検1級" ]
  }
]

# 漢字データの登録
kanjis_data.each do |kanji_data|
  tags_for_kanji = kanji_data.delete(:tags)
  kanji = Kanji.create!(kanji_data)

  # タグの関連付け
  tags_for_kanji.each do |tag_name|
    KanjiTag.create!(kanji: kanji, tag: tags[tag_name])
  end
end

puts "漢字データの登録が完了しました！"
puts "漢字: #{Kanji.count}件"
