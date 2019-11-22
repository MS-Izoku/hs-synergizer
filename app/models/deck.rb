# frozen_string_literal: true

require 'deckstrings'

class Deck < ApplicationRecord
  has_many :deck_cards
  has_many :cards, through: :deck_cards
  belongs_to :player_class

  def self.test_code
    'AAECAQcOnwP8BJAH+wz09QKS+AKO+wKz/AKggAOGnQPyqAOftwPj0gPn0gMIS6IE/wed8AKb8wKe+wKfoQOhoQMA'
  end

  # returns a hash of deck code data with DBFID's
  def self.decode(deck_code)
    code = Deckstrings.decode(deck_code)
    code
  end

  def self.generate_cards_from_code(decoded_deck_code)
    temp_deck = []
    decoded_deck_code[:cards].each do |card|
      temp_deck.push(Card.find_by(dbf_id: card))
      p Card.find_by(dbf_id: card)
    end
    temp_deck
  end

  # quick deck creation method
  def self.create_deck_from_code(encoded_deck_code)
    if(Deck.find_by(deck_code: encoded_deck_code))
      return Deck.find_by(deck_code: encoded_deck_code)
    end
    new_deck = Deck.new
    card_arr = Deck.generate_cards_from_code(Deck.decode(encoded_deck_code))


    deck_class = card_arr.each do |card|
      if card.player_class.name != 'Neutral'
        return card.player_class
      else next
      end
    end

    new_deck.player_class_id = deck_class.id
    new_deck.save
    
    p '<<<<<<<<<<<<<<<<<<<<<<<'
    p deck_class
    nil
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

  def self.encode_wild(cards, player_class)
    code = case player_class
           when 'Mage'
             Deckstrings::Deck.encode(
               format: Deckstrings::Format.wild,
               heroes: [Deckstrings::Hero.mage],
               cards: cards
             )
           when 'Paladin'
             Deckstrings::Deck.encode(
               format: Deckstrings::Format.wild,
               heroes: [Deckstrings::Hero.paladin],
               cards: cards
             )
           when 'Hunter'
             Deckstrings::Deck.encode(
               format: Deckstrings::Format.wild,
               heroes: [Deckstrings::Hero.hunter],
               cards: cards
             )
           when 'Warrior'
             Deckstrings::Deck.encode(
               format: Deckstrings::Format.wild,
               heroes: [Deckstrings::Hero.warrior],
               cards: cards
             )
           when 'Priest'
             Deckstrings::Deck.encode(
               format: Deckstrings::Format.wild,
               heroes: [Deckstrings::Hero.priest],
               cards: cards
             )
           when 'Warlock'
             Deckstrings::Deck.encode(
               format: Deckstrings::Format.wild,
               heroes: [Deckstrings::Hero.warlock],
               cards: cards
             )
           when 'Shaman'
             Deckstrings::Deck.encode(
               format: Deckstrings::Format.wild,
               heroes: [Deckstrings::Hero.shaman],
               cards: cards
             )
           when 'Rogue'
             Deckstrings::Deck.encode(
               format: Deckstrings::Format.wild,
               heroes: [Deckstrings::Hero.rogue],
               cards: cards
             )
           when 'Druid'
             Deckstrings::Deck.encode(
               format: Deckstrings::Format.wild,
               heroes: [Deckstrings::Hero.mage],
               cards: cards
             )
        end
    code
    end
end
