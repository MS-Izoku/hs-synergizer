class CardMechanic < ApplicationRecord
    has_many :card_ids
    has_many :mechanic_ids
end
