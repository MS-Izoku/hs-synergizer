class CardKeyword < ApplicationRecord
    belongs_to :card
    belongs_to :keyword
end
