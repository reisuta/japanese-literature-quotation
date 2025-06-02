class Kanji < ApplicationRecord
  has_many :kanji_tags, dependent: :destroy
  has_many :tags, through: :kanji_tags

  validates :character, presence: true, uniqueness: true
  validates :reading_on, presence: true
  validates :reading_kun, presence: true
  validates :meaning, presence: true
  validates :grade, presence: true
  validates :stroke_count, presence: true, numericality: { greater_than: 0 }

  scope :by_grade, ->(grade) { where(grade: grade) }
  scope :by_stroke_count, ->(count) { where(stroke_count: count) }
  scope :random_sample, ->(limit = 10) { order("RAND()").limit(limit) }
end
