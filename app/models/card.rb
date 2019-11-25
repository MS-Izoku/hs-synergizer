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

  def keywords
    all_keywords = []
    #arr_check = self.plain_text.split(/[()]+/).reject{|str| str == "." || str == ". "}
    p self.card_text
    temp_str = ""
    remove_periods = self.plain_text.split(".").each do |str|
      temp_str = temp_str + str
    end

    p temp_str


    arr_check = temp_str.split(/[()]+/)
    p arr_check

    all_words = arr_check.collect do |str|
      str.split(" ")
    end
    p all_words

    all_keywords
  end
end
