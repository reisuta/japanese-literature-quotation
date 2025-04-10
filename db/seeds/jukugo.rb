tags = {
  "動物" => Tag.find_or_create_by!(name: "動物"),
  "自然" => Tag.find_or_create_by!(name: "自然"),
  "感情" => Tag.find_or_create_by!(name: "感情"),
  "行動" => Tag.find_or_create_by!(name: "行動"),
  "思想" => Tag.find_or_create_by!(name: "思想"),
  "漢検1級" => Tag.find_or_create_by!(name: "漢検1級"),
  "四字熟語" => Tag.find_or_create_by!(name: "四字熟語"),
  "難読" => Tag.find_or_create_by!(name: "難読")
}

# 四字熟語・熟語のサンプルデータ
jukugos_data = [
  {
    expression: "蜿蜒曲折",
    reading: "えんえんきょくせつ",
    reading_alphabet: "enenkyokusetu",
    meaning: "道などが曲がりくねっている様子",
    difficulty: "漢検1級",
    example_sentences: "蜿蜒曲折する山道を進んでいくと、突然眼前に美しい景色が広がった。",
    tags: [ "自然", "四字熟語", "漢検1級" ]
  },
  {
    expression: "魑魅魍魎",
    reading: "ちみもうりょう",
    reading_alphabet: "timimouryou",
    meaning: "山や森に棲むとされる妖怪の総称。転じて、世の中の怪しげな者たち。",
    difficulty: "漢検1級",
    example_sentences: "山奥には魑魅魍魎が潜んでいるという伝説がある。",
    tags: [ "四字熟語", "漢検1級", "難読" ]
  },
  {
    expression: "諄諄懇懇",
    reading: "じゅんじゅんこんこん",
    reading_alphabet: "junjunkonkon",
    meaning: "丁寧に繰り返し教えること",
    difficulty: "漢検1級",
    example_sentences: "先生は諄諄懇懇と基本の大切さを説いた。",
    tags: [ "行動", "四字熟語", "漢検1級" ]
  },
  {
    expression: "鬱々悶々",
    reading: "うつうつもんもん",
    reading_alphabet: "utuutumonmon",
    meaning: "気分が晴れず、沈んだ様子",
    difficulty: "漢検1級",
    example_sentences: "彼は失敗以来、鬱々悶々とした日々を過ごしている。",
    tags: [ "感情", "四字熟語", "漢検1級" ]
  },
  {
    expression: "巍然屹立",
    reading: "ぎぜんきつりつ",
    reading_alphabet: "gizenkituritu",
    meaning: "高くそびえ立つ様子",
    difficulty: "漢検1級",
    example_sentences: "その城は城下町を見下ろすように巍然屹立していた。",
    tags: [ "自然", "四字熟語", "漢検1級" ]
  },
  {
    expression: "塵埃",
    reading: "じんあい",
    reading_alphabet: "zinai",
    meaning: "ちり。ほこり",
    difficulty: "漢検1級",
    example_sentences: "都会の塵埃に染まる",
    tags: [ "自然", "思想", "漢検1級" ]
  }
]

# 熟語データの登録
jukugos_data.each do |jukugo_data|
  tags_for_jukugo = jukugo_data.delete(:tags)
  jukugo = Jukugo.create!(jukugo_data)

  # タグの関連付け
  tags_for_jukugo.each do |tag_name|
    JukugoTag.create!(jukugo: jukugo, tag: tags[tag_name])
  end
end

puts "熟語データの登録が完了しました！"
puts "熟語: #{Jukugo.count}件"
