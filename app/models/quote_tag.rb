class QuoteTag < ApplicationRecord
  belongs_to :quote
  belongs_to :tag
end
