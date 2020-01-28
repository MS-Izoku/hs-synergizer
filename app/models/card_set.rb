# frozen_string_literal: true

class CardSet < ApplicationRecord
  has_many :cards
  has_many :artists, through: :cards

  def card_names
    temp = []
    cards.each do |card|
      temp = temp.push(card.name)
    end
    temp
  end

  def self.set_removed_cards
    Card.where(img: nil).update_all(card_set_id: CardSet.find_or_create_by(name: 'Removed').id)
    Card.where(name: Card.removed_cards).update(card_set_id: CardSet.where(name: 'Removed'))
    Card.joins(:card_set).where(card_sets: { name: [
                                  'NYI', 'Token', 'Debug', 'Hero Cards', 'Removed'
                                ] }).delete_all
  end

  def self.move_cards_to_set(set_name, _card_names)
    set = CardSet.find_by(name: set_name)
    Card.where(name: cards).update(card_set_id: set.id)
  end

  def self.removed_cards
    ['Absolution', 'Adrenaline Rush', 'Arcane Flux', "Assassin's Training",
     'Auto-Pecker 4000', 'Axe of the Eclipse', 'Avatar of the Coin',
     'Bethekk, the Panther', 'Boon of Elune', 'Captain Scaleblade',
     'Cheerful Spirit', 'Combust', 'Dark Summoner', 'Darkspear Hunter',
     'Death Wish', 'Demoralizing Roar', 'Devouring Ooze', 'Envenom',
     'Etheral Zug', 'Faceless Zug', 'Fade', 'Firebeard Herald',
     'Ghost', 'Goblin Zug', 'Grand Poet Ezzera', 'Greater Heal', 'Grimoire of Service',
     'Half-dead Walrus', 'Hardboiled Constable', 'High Mezmerist Ezzera',
     'Jadefire Satyr', 'Kobold Zug', 'Magma Shock', 'Mana Spring Totem',
     'MEGA-BLAST!!!', 'Mental Collapse', 'Mindspike', 'Oldtown Beggar',
     'Overmind Kangor', 'Ozumat', 'Power Cosmic', 'Prayer of Fortitude',
     'Puddlejumper', 'Quest for Epic Loot', 'Refreshing Jolt', 'Relic of Hope',
     'Retribution', 'Scrap Reacer', 'Sydnicate Spy', 'The Omnireaper',
     'Training Blade', 'Volley', 'Witchy Zug', 'Worldflipper X-50']
  end

  def self.hall_of_fame
    [
      'Coldlight Oracle', 'Azure Drake', "Captain's Parrot", 'Molten Giant',
      'Old Murk-Eye', 'Elite Tauren Chieftain', 'Geblin Mekkatorque', 'Genn Greymane',
      'Sylvanas Windrunner', 'Ragnaros the Firelord', 'Baku the Mooneater',
      'Chicken', 'Murloc', 'I Am Murloc', 'Power of the Horde', 'Rogues Do It...',
      'Emboldener 3000', 'Homing Chicken', 'Poultryizer', 'Repair Bot',
      'Naturalize', 'Gloom Stag', 'Ice Lance', 'Black Cat', 'Ice Block',
      'Divine Favor', 'Mind Blast', 'Glitter Moth', 'Murkspark Eel',
      'Conceal', 'Vanish', 'Power Overwhelming', 'Doomguard'
    ]
  end

  def self._special_event_sets
    set_names = ['Wild Event']
    CardSet.where(name: set_names)
  end
end
