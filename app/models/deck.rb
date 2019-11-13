# frozen_string_literal: true

require 'deckstrings'

class Deck < ApplicationRecord

  def self.test_code
    'AAECAQcOnwP8BJAH+wz09QKS+AKO+wKz/AKggAOGnQPyqAOftwPj0gPn0gMIS6IE/wed8AKb8wKe+wKfoQOhoQMA'
  end

  # returns a hash of deck code data with DBFID's
  def self.decode(deck_code)
    code = Deckstrings.decode(deck_code)
    return code
  end

  def self.generate_cards_from_code(decoded_deck_code)
    temp_deck = []
    decoded_deck_code[:cards].each do |card|
      temp_deck.push(Card.find_by(dbf_id: card))
      p Card.find_by(dbf_id: card)
    end
    temp_deck
  end

  # cards should be a hash, player class is a string
  def self.encode_standard(cards, player_class)
    code = case player_class
           when 'Mage'
             Deckstrings::Deck.encode(
               format: Deckstrings::Format.standard,
               heroes: [Deckstrings::Hero.mage],
               cards: cards
             )
           when 'Paladin'
             Deckstrings::Deck.encode(
               format: Deckstrings::Format.standard,
               heroes: [Deckstrings::Hero.paladin],
               cards: cards
             )
           when 'Hunter'
             Deckstrings::Deck.encode(
               format: Deckstrings::Format.standard,
               heroes: [Deckstrings::Hero.hunter],
               cards: cards
             )
           when 'Warrior'
             Deckstrings::Deck.encode(
               format: Deckstrings::Format.standard,
               heroes: [Deckstrings::Hero.warrior],
               cards: cards
             )
           when 'Priest'
             Deckstrings::Deck.encode(
               format: Deckstrings::Format.standard,
               heroes: [Deckstrings::Hero.priest],
               cards: cards
             )
           when 'Warlock'
             Deckstrings::Deck.encode(
               format: Deckstrings::Format.standard,
               heroes: [Deckstrings::Hero.warlock],
               cards: cards
             )
           when 'Shaman'
             Deckstrings::Deck.encode(
               format: Deckstrings::Format.standard,
               heroes: [Deckstrings::Hero.shaman],
               cards: cards
             )
           when 'Rogue'
             Deckstrings::Deck.encode(
               format: Deckstrings::Format.standard,
               heroes: [Deckstrings::Hero.rogue],
               cards: cards
             )
           when 'Druid'
             Deckstrings::Deck.encode(
               format: Deckstrings::Format.standard,
               heroes: [Deckstrings::Hero.mage],
               cards: cards
             )
        end
    code
    end
end
