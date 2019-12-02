class CardSet < ApplicationRecord
    has_many :cards
    has_many :artists , through: :cards

    def card_names
        temp = []
        self.cards.each do |card|
            temp = temp.push(card.name)
        end
        temp
    end
end

