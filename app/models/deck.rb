# frozen_string_literal: true

require 'deckstrings'

class Deck < ApplicationRecord
  # asscociations / standard-features
  has_many :deck_cards
  has_many :cards, through: :deck_cards
  belongs_to :player_class

  # polymorphic asscociations / social features
  has_many :upvotes, as: :upvotable
  has_many :comments, as: :commentable

  has_many :saved_decks
  has_many :users, through: :saved_decks

  def self.deck_creation_test
    Deck.generate_deck_from_code(Deck.test_code)
  end

  # delete this before delpoyment
  def self.test_code
    'AAECAQcOnwP8BJAH+wz09QKS+AKO+wKz/AKggAOGnQPyqAOftwPj0gPn0gMIS6IE/wed8AKb8wKe+wKfoQOhoQMA'
  end

  def self.generate_deck_from_codep(deck_code)
    return Deck.find_by(deck_code: deck_code) if Deck.find_by(deck_code: deck_code)

    code = Deck.decode(deck_code)
    cards = Card.where(dbf_id: code[:cards].keys)

    deck = Deck.find_or_create_by(
      deck_code: deck_code,
      player_class_id: PlayerClass.find_by(dbf_id: code[:heroes]).id,
      standard: code[:format] != 1,
      creator_id: 1 # TEMPORARY
    )

    # this needs to be replaced with some kind of mass-creation method
    # works for now, needs optomization (keep it out of a loop, use single query)
    cards.each do |card|
      DeckCard.create(
        deck_id: deck.id,
        card_id: card.id,
        duplicates: code[:cards][card.dbf_id] == 2
      )
    end

    cards
  end

  # returns a hash of deck code data with DBFID's
  def self.decode(deck_code)
    Deckstrings.decode(deck_code)
  end

  def self.encode(cards, player_class, deck_format)
    deck_format == 'wild' ? DeckStrings::Format.wild : DeckStrings::Format.standard
    code = case player_class
           when 'Mage'
             Deckstrings::Deck.encode(
               format: deck_format,
               heroes: [Deckstrings::Hero.mage],
               cards: cards
             )
           when 'Paladin'
             Deckstrings::Deck.encode(
               format: deck_format,
               heroes: [Deckstrings::Hero.paladin],
               cards: cards
             )
           when 'Hunter'
             Deckstrings::Deck.encode(
               format: deck_format,
               heroes: [Deckstrings::Hero.hunter],
               cards: cards
             )
           when 'Warrior'
             Deckstrings::Deck.encode(
               format: deck_format,
               heroes: [Deckstrings::Hero.warrior],
               cards: cards
             )
           when 'Priest'
             Deckstrings::Deck.encode(
               format: deck_format,
               heroes: [Deckstrings::Hero.priest],
               cards: cards
             )
           when 'Warlock'
             Deckstrings::Deck.encode(
               format: deck_format,
               heroes: [Deckstrings::Hero.warlock],
               cards: cards
             )
           when 'Shaman'
             Deckstrings::Deck.encode(
               format: deck_format,
               heroes: [Deckstrings::Hero.shaman],
               cards: cards
             )
           when 'Rogue'
             Deckstrings::Deck.encode(
               format: deck_format,
               heroes: [Deckstrings::Hero.rogue],
               cards: cards
             )
           when 'Druid'
             Deckstrings::Deck.encode(
               format: deck_format,
               heroes: [Deckstrings::Hero.mage],
               cards: cards
             )
        end
    code
    end
end
