FactoryBot.define do
  factory :jukugo do
    sequence(:expression) { |n| "熟語#{n}" }
    reading { "ジュクゴ" }
    reading_alphabet { "jukugo" }
    meaning { "compound word" }
    difficulty { "beginner" }
    example_sentences { "熟語を覚える。" }
  end
end
