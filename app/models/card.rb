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

  def self.zilliax
    Card.find_by(name: "Zilliax" , cost: 5)
  end

  def self.brann
    Card.find_by(name: "Dinotamer Brann" , cost: 7)
  end

  def list_mechanics
    self.mechanics.each do |mechanic|
      p mechanic.name
    end
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

    text = text.sub! '_', ' ' # underscores sometimes come in with certain token/stat cards

    temp_str.sub('_', ' ')
  end

  def generate_keywords
    all_keywords = {
      minions: [],
      tokens: [],
      mechanics: [],
    }

    pt = self.plain_text.downcase

    Mechanic.names.each do |mechanic|
      next unless pt.include?(" #{mechanic.downcase}") || pt.include?("#{mechanic.downcase} ")
      p mechanic.downcase
      all_keywords[:mechanics].push(mechanic)
      pt.slice!(mechanic.downcase)
    end

    Card.names.each do |name|
      next unless pt.include?(" #{name.downcase}") || pt.include?("#{name.downcase} ")

      p Card.find_by(name: name).name
      all_keywords[:minions].push(name)
      pt.slice!(name)
    end
    pt
    #all_keywords
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
     'summon' , "restore" , "reduce the cost"]
  end

  def parse_key_phrases
    all_keywords = {
      remaining_plain_text: plain_text.downcase,
      keywords: {

      }
    }

    Card.key_phrases.collect do |phrase|
      next unless all_keywords[:remaining_plain_text].include?(phrase)

      p phrase
      case phrase
      when 'if your deck has no duplicates'
        puts 'SINGLETON FOUND'
        all_keywords[:keywords]['singleton'] = 1
        next
      when "your opponent's cards"
        puts 'DISRUPTION FOUND'
        if all_keywords[:keywords]['disruption'].nil? 
          all_keywords[:keywords]['disruption'] = 0 
        else
           all_keywords[:keywords]['disruption'] += 1
        end
        next
      when 'at the start of your turn'
        puts 'START OF TURN FOUND'
        next
      when '50% chance to'
        puts 'OGRE FOUND'
        next
      when 'if your board is full of'
        puts 'MOGU CULTIST FOUND'
        next
      when 'whenever you play'
        puts 'ON CARD PLAY FOUND'
        next
      when 'after you'
        puts 'AFTER PLAYER ACTION FOUND'
        next
      when 'each player'
        puts 'EACH-PLAYER FOUND'
        next
      when 'reveal a'
        puts 'SINGLETON FOUND'
        next
      when 'for each'
        puts 'SINGLETON FOUND'
        next
      when "if you're holding a spell that costs (5) or more"
        puts 'SINGLETON FOUND'
        next
      when 'if you have unspent mana at the end of your turn'
        puts 'SINGLETON FOUND'
        next
      when 'if you control'
        puts 'SINGLETON FOUND'
        next
      when 'it costs'
        puts 'SINGLETON FOUND'
        next
      when 'after you play'
        puts 'SINGLETON FOUND'
        next
      when 'after you cast'
        puts 'SINGLETON FOUND'
        next
      when 'targets chosen randomly'
        puts 'SINGLETON FOUND'
        next
      when 'split among'
        puts 'SINGLETON FOUND'
        next
      when "set a minion's"
        puts 'SINGLETON FOUND'
        next
      when  'from your deck'
        puts 'SINGLETON FOUND'
        next
      when  'hero power'
        puts 'SINGLETON FOUND'
        next
      when  'return it to life'
        puts 'SINGLETON FOUND'
        next
      when 'after you summon a'
        puts 'SINGLETON FOUND'
        next
      when 'return a'
        puts 'SINGLETON FOUND'
        next
      when 'change each'
        puts 'SINGLETON FOUND'
        next
      when 'equip a'
        puts 'SINGLETON FOUND'
        next
      when 'casts when drawn'
        puts 'SINGLETON FOUND'
        next
      when 'summons when'
        puts 'SINGLETON FOUND'
        next
      when "while you're"
        puts 'SINGLETON FOUND'
        next
      when 'your hero takes damage'
        puts 'SINGLETON FOUND'
        next
      when 'discard'
        puts 'SINGLETON FOUND'
        next
      when 'for the rest of the game'
        puts 'SINGLETON FOUND'
        next
      when 'whenever your hero attacks'
        puts 'SINGLETON FOUND'
        next
      when 'choose a'
        puts 'SINGLETON FOUND'
        next
      when 'if you have'
        puts 'SINGLETON FOUND'
        next
      when 'spell damage'
        puts 'SINGLETON FOUND'
        next
      when 'your spells cost'
        puts 'SINGLETON FOUND'
        next
      when 'your opponents spells cost'
        puts 'SINGLETON FOUND'
        next
      when 'copy a'
        puts 'SINGLETON FOUND'
        next
      when 'whenever this minion'
        puts 'SINGLETON FOUND'
        next
      when "can't be targeted by spells or hero powers"
        puts 'SINGLETON FOUND'
        next
      when 'until your next turn'
        puts 'SINGLETON FOUND'
        next
      when 'take an extra turn'
        puts 'SINGLETON FOUND'
        next
      when "fill each player's"
        puts 'SINGLETON FOUND'
        next
      when 'after this minion survives damage'
        puts 'SURVIVAL FOUND'
        next
      when 'at the start your turn'
        puts 'START-OF-TURN FOUND'
        next
      when 'your minions with'
        puts 'MINION BUFF FOUND'
        next
      when 'casts a random'
        puts 'RANDOM-CAST FOUND'
        next
      when 'plays a random'
        puts 'RANDOM-PLAY FOUND'
        next
      when 'start the game'
        puts 'START-OF-GAME FOUND'
        next
      when 'if your deck is empty'
        puts 'NOMI FOUND'
        next
      when 'if you have no'
        puts 'IF-YOU-HAVE-NO FOUND'
        next
      when 'if your hand has no'
        puts 'IF-YOUR-HAND-HAS-NO FOUND'
        # minions
        # spells
        # tribal?
        next
      when 'go dormant'
        puts 'DORMANT FOUND'
        next
      when 'the first'
        puts 'THE-FIRST FOUND'
        # spell
        # minion
        next
      when 'your first'
        puts 'YOUR-FIRST FOUND'
        next
      when 'your cards that summon minions'
        puts 'KHADGAR FOUND'
        if all_keywords[:keywords]["summon"].nil?
          all_keywords[:keywords]["summon"] = 1
        else
          all_keywords[:keywords]["summon"] += 1
        end
        next
      when "if you're holding a dragon"
        puts 'DRAGON HOLDING FOUND'
        all_keywords[:keywords]["dragon"] = 1
        next
      when 'if you played an elemental last turn'
        puts 'ELEMENTAL CHAIN FOUND'
        all_keywords[:keywords]
        next
      when 'if you have 10 mana crystals'
        puts 'OMEGA FOUND'
        all_keywords[:keywords]["omega"] = 1
        next
      when 'summon'
        puts 'SUMMONING FOUND'
        # summon a
        # summon x-many
        # summon specific minion
        next
      when 'restore'
        puts "HEALTH-RESTORE FOUND"
        # parse int from the string , then find the target type
        next
      when 'reduce the cost'
        puts "CARD REDUCTION"
        reduction_amount = 1 # get the actual value from a string parse
        all_keywords[:keywords]["cost-reduction"] = reduction_amount
        next
      else
        puts "Phrase --#{phrase}-- not found"
        next
      end

      all_keywords[:remaining_plain_text].slice!(phrase)
      p all_keywords[:remaining_plain_text]
    end

    all_keywords
  end

  def quick_split_string(inp_string , splitter_string)
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
