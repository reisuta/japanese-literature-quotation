class Jukugo < ApplicationRecord
  has_many :jukugo_tags, dependent: :destroy
  has_many :tags, through: :jukugo_tags

  validates :expression, presence: true, uniqueness: true
  validates :reading, presence: true
  validates :reading_alphabet, presence: true
  validates :meaning, presence: true
  validates :difficulty, presence: true

  scope :by_difficulty, ->(difficulty) { where(difficulty: difficulty) }
  scope :random_sample, ->(limit = 10) { order("RAND()").limit(limit) }
end
