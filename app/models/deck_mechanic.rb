class DeckMechanic < ApplicationRecord
    belongs_to :deck
    belongs_to :mechanic_id
end
