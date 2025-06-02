FactoryBot.define do
  factory :score do
    user_name { "MyString" }
    score_type { "MyString" }
    wpm { 1.5 }
    accuracy { 1.5 }
    time_taken { 1.5 }
    completed_at { "2025-06-02 02:15:13" }
  end
end
