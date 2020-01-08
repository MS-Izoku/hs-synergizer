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
    temp.to_a
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

    #p text
    # Something is happening here that is causing issues splitting up the string
    text.split('[x]').reject { |str| str == '' }.each { |str| temp_str += str }
    text = temp_str
    #p temp_str

    temp_str = ''
    text.split(':').reject { |str| str == '' }.each { |str| temp_str += str }
    text = temp_str
    #p temp_str

    text = text.split('\\n')
    temp_str = ''
    text.each do |str|
      str += ' '
      temp_str += str
    end
    text = temp_str
    #p temp_str

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
    [
      '50% chance to',
      'after this minion survives damage',
      'after you',
      'after you cast',
      'after you play',
      'after you summon a',
      'at the start of your turn',
      'at the start your turn',
      "can't be targeted by spells or hero powers",
      'casts a random',
      'casts when drawn',
      'change each',
      'choose a',
      'copy a',
      'discard',
      'each player',
      'equip a',
      "fill each player's",
      'for each',
      'for the rest of the game',
      'from your deck',
      'go dormant',
      'hero power',
      'if you control',
      'if you have',
      'if you have 10 mana crystals',
      'if you have no',
      'if you have unspent mana at the end of your turn',
      'if you played an elemental last turn',
      "if you're holding a dragon",
      "if you're holding a spell that costs (5) or more",
      'if your board is full of',
      'if your deck has no duplicates',
      'if your deck is empty',
      'if your hand has no',
      'it costs',
      'plays a random',
      'reduce the cost',
      'restore',
      'return a',
      'return it to life',
      'reveal a',
      "set a minion's",
      'spell damage',
      'split among',
      'start the game',
      'summon',
      'summons when',
      'take an extra turn',
      'targets chosen randomly',
      'the first',
      'until your next turn',
      'whenever this minion',
      'whenever you play',
      'whenever your hero attacks',
      "while you're",
      'your cards that summon minions',
      'your first',
      'your hero takes damage',
      'your minions with',
      "your opponent's cards",
      'your opponents spells cost',
      'your spells cost'
    ]
  end

  def self.kw_targets
    {
      self: %w[you your],
      opponent: ['opponent', "opponent's"],
      both: ['each player', 'both players'],
      deck: %w[deck decks]
    }
  end

  def self.kw_effects
    {

    }
  end

  def self.core_mechanics
    %w[draw play]
  end

  def self.kw_stats
    {
      attack: [*0..100],
      health: [*0..100],
      cost: ['cost']
    }
  end

  def self.kw_effect_timing
    {
      start_or_turn: [],
      end_of_turn: [],
      on_draw: ['casts when drawn', 'draw a card'],
      start_of_game: ['start of game'],
      end_of_game: ['end of game']
    }
  end

  def self.kw_conditionals
    ['whenever', 'if']
  end

  # parse through sentence to find conditional phrase
  def self.find_condition(sentence)
    condition = {
      plain_text: "",
      timing: "",
      target: "",
      action: "",
      action_target: "",
      effect: ""
    }

    sentence = sentence.split(" ")
    p sentence

    sentence.collect do |word|
      # check if the word is in the Card.kw_conditional array
    end

    condition
  end

  def split_sentences
    sentences = self.plain_text.split(".")
    while sentences.include?(" ") do
      sentences = check_for_blanks_in_arr(sentences)
    end
    sentences
  end

  def check_for_blanks_in_arr(arr)
    if arr.include?(" ")
      ind = arr.find_index(" ")
      arr.delete_at(ind)
    end
    arr
  end

  def self.kw_actions
    %w[holding played attack]
  end

  # used for sorting out keywords when a new one is added
  def self.kw_sort
    key_phrases.sort.each do |phrase|
      puts "\"#{phrase}\","
    end
    nil
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
