# frozen_string_literal: true

require 'nokogiri'

class Card < ApplicationRecord
  belongs_to :artist, optional: :true
  belongs_to :card_set
  belongs_to :player_class, optional: :true
  belongs_to :tribe, optional: :true

  has_many :card_mechanics
  has_many :mechanics, through: :card_mechanics

  has_many :card_keywords
  has_many :keywords, through: :card_keywords

  def is_standard?
    card_set.standard
  end

  def self.standard_cards
    temp = []
    CardSet.where(standard: true).each do |set|
      set.cards.each do |card|
        temp.push(card)
      end
    end
    temp
  end

  def self.wild_cards
    temp = standard_cards
    CardSet.where(standard: false).each do |set|
      next if set.year.nil?

      set.cards.each do |card|
        temp.push(card)
      end
    end
    temp
  end

  def self.find_by_tribe(tribe_name)
    cards = Tribe.find_by(name: tribe_name).cards
    # return split_array(cards , 100)
    cards
  end

  def self.find_by_tribe_wild(_tribe_name)
    wild_cards
  end

  def self.split_array(array, cards_per_array)
    result = []
    subArr = []
    array.each do |card|
      if subArr.length < cards_per_array
        subArr.push(card)
      else
        result.push(subArr)
        subArr = []
        subArr.push(card)
      end
    end
    result
  end

  def self.names
    temp = []
    Card.all.each do |card|
      temp.push(card.name)
    end
    temp
  end

  # this should not live here, not in this class
  def plain_text
    # needs optomization, not dry enough
    text = Nokogiri::HTML(card_text).text
    temp_str = ''
    text.split('[x]').reject { |str| str == '' }.each { |str| temp_str += str }
    text = temp_str

    temp_str = ''
    text.split(':').reject { |str| str == '' }.each { |str| temp_str += str }
    text = temp_str

    text = text.split('\\n')
    temp_str = ''
    text.each do |str|
      str += ' '
      temp_str += str
    end
    text = temp_str

    text
  end

  def generate_keywords
    all_keywords = {
      minions: [],
      tokens: []
    }
    plain_text = self.plain_text.downcase
    Card.key_phrases.each do |phrase|
      if plain_text.include?(phrase)
        all_keywords[phrase] = 1
        plain_text.slice!(phrase)
      else next
      end
    end

    Mechanic.names.each do |mechanic|
      if plain_text.include?(" #{mechanic.downcase}") || plain_text.include?("#{mechanic.downcase} ")
        all_keywords[mechanic] = 1
        plain_text.slice!(mechanic)
      end
    end

    Card.names.each do |name|
      if plain_text.include?(name.downcase)
        p Card.where(name: name)
        all_keywords[:minions].push(name)
        plain_text.slice!(name)
      end
    end

    p plain_text

    all_keywords
  end

  def self.key_phrases
    ['if your deck has no duplicates', "your opponent's cards", 'at the start of your turn', '50% chance to',
     'if your board is full of', 'whenever you play', 'after you', 'each player', 'reveal a', 'for each',
     "if you're holding a spell that costs (5) or more", 'if you have unspent mana at the end of your turn',
     'if you control', 'it costs', 'after you play', 'after you cast', 'targets chosen randomly', 'split among', "set a minion's",
     'from your deck', 'hero power', 'return it to life', 'after you summon a minion', 'return a', 'change each',
     'equip a', 'casts when drawn', 'summons when', "while you're", 'your hero takes damage', 'discard', 'for the rest of the game',
     'whenever your hero attacks', 'choose a', 'if you have', 'spell damage', 'your spells cost', 'your opponents spells cost', 'copy a',
     'whenever this minion', "can't be targeted by spells or hero powers", 'until your next turn', 'take an extra turn', "fill each player's",
     'after this minion survives damage', 'at the start your turn', 'your minions with', 'casts a random', 'plays a random',
     'start the game', 'if your deck is empty', 'if you have no', 'if your hand has no', 'go dormant', 'the first', 'your first',
     'your cards that summon minions', "if you're holding a dragon" , "if you played an elemental last turn"]
  end

  private

  def word_split(phrase)
    phrase.split(' ')
  end
end
