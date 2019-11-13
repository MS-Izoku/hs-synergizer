class CardSet < ApplicationRecord
    has_many :cards
    has_many :artists , through: :cards
end
