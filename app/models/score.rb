class Score < ApplicationRecord
  validates :user_name, presence: true
  validates :score_type, presence: true, inclusion: { in: %w[quotes kanjis jukugos] }
  validates :wpm, presence: true, numericality: { greater_than: 0 }
  validates :accuracy, presence: true, numericality: { in: 0.0..100.0 }
  validates :time_taken, presence: true, numericality: { greater_than: 0 }
  validates :completed_at, presence: true

  scope :by_score_type, ->(type) { where(score_type: type) }
  scope :by_user, ->(user_name) { where(user_name: user_name) }
  scope :recent, -> { order(completed_at: :desc) }
  scope :top_scores, ->(limit = 10) { order(wpm: :desc).limit(limit) }
end
