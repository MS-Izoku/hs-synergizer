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
    Deck.generate_cards_from_code(Deck.test_code)
  end

  # delete this before delpoyment
  def self.test_code
    'AAECAQcOnwP8BJAH+wz09QKS+AKO+wKz/AKggAOGnQPyqAOftwPj0gPn0gMIS6IE/wed8AKb8wKe+wKfoQOhoQMA'
  end

  def self.generate_cards_from_code(deck_code)
    code = Deck.decode(deck_code)
    cards = Card.where(dbf_id: code[:cards].keys)
    card_ids = cards.ids

    deck = Deck.find_or_create_by(
      deck_code: deck_code,
      player_class_id: PlayerClass.find_by(dbf_id: code[:heroes]).id,
      standard: code[:format] != 1,
      creator_id: 1 # TEMPORARY
    )

    cards.each do |card| 
      DeckCard.create(
        deck_id: deck.id,
        card_id: card.id,
        duplicates: code[:cards][card.dbf_id] == 2
      ) 
    end

    deck
  end

  # this could be optomized better
  def self.new_create_deck_from_code(deck_code)
    parsed_deck_code = Deck.decode(deck_code)
    is_standard_deck = (parsed_deck_code[:format] == 2)
    pc = PlayerClass.find_by(dbf_id: parsed_deck_code[:heroes][0])

    temp_deck = Deck.find_or_create_by(deck_code: deck_code, standard: is_standard_deck, player_class_id: pc.id)
    parsed_deck_code[:cards].collect do |card, card_count|
      temp_card = Card.find_by(dbf_id: card)
      deck_inclusion = DeckCard.find_by(card_id: temp_card.id, deck_id: temp_deck.id)
      unless deck_inclusion
        has_duplicates = (card_count == 2)
        DeckCard.create(card_id: temp_card.id, deck_id: temp_deck.id, duplicates: has_duplicates)
      end
    end

    temp_deck
  end

  # used when the deck cards need to be sorted by mana-cost / alphabetically (in that order)
  def order_cards
    sorted_cards = { result: [] }
    cards.each do |card|
      sorted_cards[card.mana_cost] ||= []
      sorted_cards[card.mana_cost].push(card)
    end

    sorted_cards.each do |card_set|
      card_set.sort { |card_a, card_b| card_a.name <=> card_b.name }
      sorted_cards[:results].push(card_set)
    end
    p sorted_cards[:results].flatten
  end

  # need to find a use for this, might just be in the update method in the controller
  def change_cards(updated_deck_code)
    temp_cards = generate_cards_from_code(updated_deck_code)
    current_cards = generate_cards_from_code(deck_code)
    if temp_cards != current_cards

      return new_card_hash
    else return false
    end
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
