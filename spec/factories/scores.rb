FactoryBot.define do
  factory :score do
    user_name { "TestUser" }
    score_type { "quotes" }
    wpm { 50.0 }
    accuracy { 95.5 }
    time_taken { 120.0 }
    completed_at { Time.current }

    trait :kanji_score do
      score_type { "kanjis" }
    end

    trait :jukugo_score do
      score_type { "jukugos" }
    end

    trait :high_score do
      wpm { 80.0 }
      accuracy { 98.0 }
    end

    trait :low_score do
      wpm { 20.0 }
      accuracy { 75.0 }
    end
  end
end
