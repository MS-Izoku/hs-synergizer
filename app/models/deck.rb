require 'deckstrings'

class Deck < ApplicationRecord
  has_many :deck_cards
  has_many :cards, through: :deck_cards
  belongs_to :player_class

  def self.test_code
    'AAECAQcOnwP8BJAH+wz09QKS+AKO+wKz/AKggAOGnQPyqAOftwPj0gPn0gMIS6IE/wed8AKb8wKe+wKfoQOhoQMA'
  end

  def create_card_asscociation(card_hash)
    # this needs to be able to incorporate stuff form the dbf_ids since it tracks duplicates
  end

  def order_cards
    sorted_cards = { result: [] }
    self.cards.each do |card|
      sorted_cards[card.mana_cost] ||= []
      sorted_cards[card.mana_cost].push(card)
    end

    sorted_cards.each { |card_set|
      card_set.sort { |card_a , card_b| card_a.name <=> card_b.name }
      sorted_cards[:results].push(card_set)
    }
    p sorted_cards[:results].flatten
  end

  def change_cards(updated_deck_code)
    temp_cards = generate_cards_from_code(updated_deck_code)
    current_cards = generate_cards_from_code(self.deck_code)
    if temp_cards != current_cards

      return new_card_hash
    else return false
    end
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
    end
    temp_deck
  end

  # quick deck creation method
  def self.create_deck_from_code(encoded_deck_code)
    if(Deck.find_by(deck_code: encoded_deck_code))
      return Deck.find_by(deck_code: encoded_deck_code)
    end

    new_deck = Deck.new
    deck_from_code = Deck.decode(encoded_deck_code)
    # p deck_from_code
    # p "<<<<<<<<<"
    deck_cards = Deck.generate_cards_from_code(deck_from_code)

    deck_class = PlayerClass.find_by(dbf_id: deck_from_code[:heroes])
    # p deck_class
    # p "<<<<<<<<<<<<"

    # get the Player class deck-code identifier to use in the deck creating method

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
