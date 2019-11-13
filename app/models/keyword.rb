class Keyword < ApplicationRecord
    has_many :card_keywords
    has_many :keywords , through: :card_keywords
end
