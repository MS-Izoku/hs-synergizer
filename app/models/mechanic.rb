class Mechanic < ApplicationRecord

    has_many :card_mechanics
    has_many :cards , through: :card_mechanics

    has_many :deck_mechanics
    has_many :decks , through: :deck_mechanics

    def self.names
        temp = []
        Mechanic.all.each { |mechanic| temp.push(mechanic.name.downcase) }
        return temp
    end
end
