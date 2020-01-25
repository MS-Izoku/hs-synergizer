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

  def self.cards_with_mechanic(mechanic_name , standard)
    mechanic = Mechanic.find_by(name: mechanic_name)
    if standard
      Card.joins(:card_mechanics, :card_set).where(card_mechanics: {mechanic_id: mechanic.id} , card_sets: {standard: standard} )
    else
      Card.joins(:card_mechanics).where(card_mechanics: {mechanic_id: mechanic.id})
    end
  end
end
