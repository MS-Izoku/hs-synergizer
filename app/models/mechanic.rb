# frozen_string_literal: true

class Mechanic < ApplicationRecord
  has_many :card_mechanics
  has_many :cards, through: :card_mechanics

  def self.names(show_in_console = false)
    temp = []

    Mechanic.all.each do |mechanic|
      temp.push(mechanic.name.downcase)
      puts mechanic.name if show_in_console
    end
    temp.sort!
  end

  def self.cards_with_mechanic(mechanic_name, standard)
    mechanic_id = Mechanic.find_by(name: mechanic_name).id
    sets = CardSet.where(standard: standard)
    p sets
    p "SETS"
    cards = []

    

    cards
  end
end
