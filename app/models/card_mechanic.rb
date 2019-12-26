class CardMechanic < ApplicationRecord
    belongs_to :card
    belongs_to :mechanic
end
