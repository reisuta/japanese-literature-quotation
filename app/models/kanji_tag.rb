class KanjiTag < ApplicationRecord
  belongs_to :kanji
  belongs_to :tag
end
