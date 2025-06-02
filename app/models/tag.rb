class Tag < ApplicationRecord
  has_many :quote_tags, dependent: :destroy
  has_many :quotes, through: :quote_tags

  has_many :kanji_tags, dependent: :destroy
  has_many :kanjis, through: :kanji_tags

  has_many :jukugo_tags, dependent: :destroy
  has_many :jukugos, through: :jukugo_tags

  validates :name, presence: true, uniqueness: true
end
