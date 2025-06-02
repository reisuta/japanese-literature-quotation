json.array! @kanjis do |kanji|
  json.array! [ kanji.reading_on, kanji.character, kanji.meaning ]
end