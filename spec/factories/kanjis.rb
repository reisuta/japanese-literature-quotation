FactoryBot.define do
  factory :kanji do
    sequence(:character) { |n| "漢#{n}" }
    reading_on { "カン" }
    reading_kun { "かん" }
    meaning { "Chinese character" }
    grade { "1" }
    stroke_count { 5 }
    example_words { "漢字,漢文" }
    example_sentences { "漢字を勉強する。" }
    radical { "氵" }
  end
end
