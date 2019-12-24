# frozen_string_literal: true

require 'nokogiri'
require 'numbers_in_words'
require 'pry'

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

  def self.all_cards # Card.all gives some useless cards
    Card.where.not(collectable: nil)
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

    p text
    # Something is happening here that is causing issues splitting up the string
    text.split('[x]').reject { |str| str == '' }.each { |str| temp_str += str }
    text = temp_str
    p temp_str

    temp_str = ''
    text.split(':').reject { |str| str == '' }.each { |str| temp_str += str }
    text = temp_str
    p temp_str

    text = text.split('\\n')
    temp_str = ''
    text.each do |str|
      str += ' '
      temp_str += str
    end
    text = temp_str
    p temp_str

    text = text.sub! '_', ' ' # underscores sometimes come in with certain token/stat cards

    temp_str.sub('_', ' ')
  end

  def generate_keywords
    all_keywords = {
      minions: [],
      tokens: []
    }

    plain_text = self.plain_text.downcase

    # this will be replaced with the parse_key_phrases when complete
    # Card.key_phrases.each do |phrase|
    #   if plain_text.include?(phrase)
    #     all_keywords[phrase] = 1
    #     plain_text.slice!(phrase)
    #   else next
    #   end
    # end
    parse_key_phrases
    # parse_key_phrases

    Mechanic.names.each do |mechanic|
      if plain_text.include?(" #{mechanic.downcase}") || plain_text.include?("#{mechanic.downcase} ")
        all_keywords[mechanic] = 1
        plain_text.slice!(mechanic)
      end
    end

    Card.names.each do |name|
      next unless plain_text.include?(name.downcase)

      p Card.where(name: name)
      all_keywords[:minions].push(name)
      plain_text.slice!(name)
    end

    p plain_text
    p check_for_stats
    all_keywords
  end

  def self.key_phrases
    ['if your deck has no duplicates', "your opponent's cards", 'at the start of your turn', '50% chance to',
     'if your board is full of', 'whenever you play', 'after you', 'each player', 'reveal a', 'for each',
     "if you're holding a spell that costs (5) or more", 'if you have unspent mana at the end of your turn',
     'if you control', 'it costs', 'after you play', 'after you cast', 'targets chosen randomly', 'split among', "set a minion's",
     'from your deck', 'hero power', 'return it to life', 'after you summon a', 'return a', 'change each',
     'equip a', 'casts when drawn', 'summons when', "while you're", 'your hero takes damage', 'discard', 'for the rest of the game',
     'whenever your hero attacks', 'choose a', 'if you have', 'spell damage', 'your spells cost', 'your opponents spells cost', 'copy a',
     'whenever this minion', "can't be targeted by spells or hero powers", 'until your next turn', 'take an extra turn', "fill each player's",
     'after this minion survives damage', 'at the start your turn', 'your minions with', 'casts a random', 'plays a random',
     'start the game', 'if your deck is empty', 'if you have no', 'if your hand has no', 'go dormant', 'the first', 'your first',
     'your cards that summon minions', "if you're holding a dragon", 'if you played an elemental last turn', 'if you have 10 mana crystals',
     'if your hand has no']
  end

  def parse_key_phrases
    all_keywords = {
      remaining_plain_text: ''
    }

    text = plain_text
    Card.key_phrases.each do |phrase|
      next unless text.include?(phrase)

      if phrase == 'if your deck has no duplicates'
        # CardMechanic.create(card_id: self.id , mechanic_id: Mechanic.find_or_create_by(name: ""))
        CardMechanic.create(card_id: id, mechanic_id: Mechanic.find_or_create_by(name: 'singleton'))
      elsif phrase == 'return it to life'
        # CardMechanic.create(card_id: self.id , mechanic_id: Mechanic.find_or_create_by(name: "ressurect").id)
        make_card_mechanic('ressurect')
      elsif phrase == 'if your deck is empty'
        CardMechanic.create(card_id: id, mechanic_id: Mechanic.find_or_create_by(name: 'empty deck').id)
      elsif phrase == "if you're holding a dragon"
        tribe = Tribe.find_by(name: 'Dragon')
        CardMechanic.create(card_id: id, mechanic_id: Mechanic.find_or_create_by(name: 'tribal', tribal_synergy_id: tribe.id))
      elsif phrase == "your opponent's cards"
        # CardMechanic.create(card_id: self.id , mechanic_id: Mechanic.find_or_create_by(name: "disruption"))
        make_card_mechanic('disruption')
      elsif phrase == 'if you played an elemental last turn'
        tribe = Tribe.find_by(name: 'elemental')
        CardMechanic.create(card_id: id, mechanic_id: Mechanic.find_or_create_by(name: 'tribal', tribal_synergy_id: tribe.id))
      elsif phrase == 'give it'
        # some kind of buff
        nil
      elsif phrase == 'if you have no'
        # x cost minions
        # spells
        # minions
        nil
      elsif phrase == 'your spells cost'
        # go through the phrase to find the "your spells cost", then parse the integer in ()
        CardMechanic.create(card_id: id, mechanic_id: Mechanic.find_or_create_by(name: 'cost change').id, cost_change: 1)
      elsif phrase == 'at the end of your turn'
        make_card_mechanic('end of turn')
      elsif phrase == 'from your deck'
          
      else
        target_mechanic = Mechanic.find_by(name: phrase)
      end

      text.slice!(phrase)
    end
    all_keywords[:remaining_plain_text] = text

    all_keywords
  end

  def make_card_mechanic(mechanic_name)
    mechanic = Mechanic.find_or_create_by(name: mechanic_name)
    CardMechanic.create(mechanic_id: mechanic.id, card_id: card.id)
  end

  def slice_mechanic_from_card(input_str, mechanic_name); end

  def on_create
    parse_key_phrases # go though key phrases
    # generate_keywords # find bolded / single-word keywords
  end

  private

  def check_for_stats(input_str = plain_text)
    inp = input_str.downcase
    stat_hash = {}
    if inp.include?('/')
      slash_index = inp.index('/')
      p "Slash Index: #{slash_index}"

      stat_values = inp.scan(/\d+|\bone\b|two|three|four|five|six|seven|eight|nine|ten/)
      if stat_values.length > 2
        stat_hash[:count] = NumbersInWords.in_numbers(stat_values[0])
        stat_hash[:attack] = stat_values[1]
        stat_hash[:health] = stat_values[2]
      else
        stat_hash[:count] = 1
        stat_hash[:attack] = stat_values[0]
        stat_hash[:health] = stat_values[1]
      end
    end

    stat_hash
  end

  def check_for_minion_type_synergy(input_str, tribe_name)
    Tribe.find_by(name: tribe_name) if input_str.include?(tribe_name)
  end

  def word_split(phrase)
    phrase.split(' ')
  end
end
