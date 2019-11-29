# frozen_string_literal: true

require 'uri'
require 'net/http'
require 'openssl'
require 'pry'
require 'pretty_json'

Mechanic.create(name: "Summon")
Mechanic.create(name: "Choose One")
Mechanic.create(name: "Passive")

skip_fetch = false # Set this to false when you need to fetch
if skip_fetch == false
  puts 'Fetching Card Data <<<<<<'

  url = URI("https://omgvamp-hearthstone-v1.p.rapidapi.com/cards")

  http = Net::HTTP.new(url.host, url.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE

  request = Net::HTTP::Get.new(url)
  request["x-rapidapi-host"] = 'omgvamp-hearthstone-v1.p.rapidapi.com'
  request["x-rapidapi-key"] = 'c15502ebd8msh183a4fdd23c6591p1954c4jsn302be1511f5b'

  response = http.request(request)
  #puts response.read_body
  puts PrettyJSON.new(response.read_body)
  
  data = JSON.parse(response.read_body)
  # url = URI('https://omgvamp-hearthstone-v1.p.rapidapi.com/cards')

  # http = Net::HTTP.new(url.host, url.port)
  # http.use_ssl = true
  # http.verify_mode = OpenSSL::SSL::VERIFY_NONE

  # request = Net::HTTP::Get.new(url)
  # request['x-rapidapi-host'] = 'omgvamp-hearthstone-v1.p.rapidapi.com'
  # request['x-rapidapi-key'] = 'c15502ebd8msh183a4fdd23c6591p1954c4jsn302be1511f5b'

  # response = http.request(request)
  # puts 'PARSING JSON <<<<<<<<<'
  # data = JSON.parse(response.read_body)
  
 # binding.pry

  data.each do |_card_set_name, set_data|
    p "> Creating Set: #{_card_set_name}"
    my_set = CardSet.create(name: _card_set_name)
    #binding.pry
    set_data.each do |card|
      new_card = Card.new
      new_card.name = card['name']
      p ">> Creating Card: #{new_card.name}"
      new_card.dbf_id = card['dbfId']

      new_card.cost = card['cost'].to_i
      new_card.health = card['health'].to_i
      new_card.attack = card['attack'].to_i
      new_card.armor = card['armor'].to_i

      pc_name = card['playerClass']
      if card['playerClass'] == nil
        pc_name = "Neutral"
      end
      pc = PlayerClass.find_by(name: pc_name)
      pc ||= PlayerClass.create(name: pc_name)
      new_card.player_class_id = pc.id

      tribe = Tribe.find_by(name: card['race'])
      tribe ||= Tribe.create(name: card['race'])
      new_card.tribe_id = tribe.id

      new_card.elite = card['elite']
      new_card.collectable = card['collectable']
      new_card.rarity = card['rarity']

      cost = 0
      case new_card.rarity
      when 'Free'
        cost = 0
      when 'Common'
        cost = 40
      when 'Rare'
        cost = 100
      when 'Epic'
        cost = 400
      when 'Legendary'
        cost = 1600
      end
      new_card.dust_cost = cost

      new_card.card_text = card['text']
      new_card.flavor_text = card['flavor']

      new_card.img = card['img']
      new_card.img_gold = card['imgGold']

      new_card.durability = card['durability']
      my_artist = Artist.find_by(name: card['artist'])
      my_artist ||= Artist.create(name: card['artist'])
      new_card.artist_id = my_artist.id

      # UNTESTED
      case card
      when card['health'] != nil && card['attack'] != nil
        new_card.card_type "Minion"
      when card['durability'] != nil && card['attack'] != nil
        new_card.card_type "Weapon"
      else
        new_card.card_type = "Spell"
      end
      ">>>> Set Card Type to: #{new_card.card_type}"
      # new_card.card_type = card_type
      # UNTESTED END

      if card['mechanics']
        mechanics = card['mechanics']
        mechanics.each do |mechanic|
          temp_mechanic = Mechanic.find_by(name: mechanic['name'])
          if temp_mechanic.nil?
            if mechanic['name'] != nil
                temp_mechanic = Mechanic.create(name: mechanic['name'])
            else
                temp_mechanic = Mechanic.create(name: mechanic['name'])
            end
            m_name = mechanic['name']
            p ">>> Creating Mechanic: #{m_name}"
          end
          CardMechanic.create(mechanic_id: temp_mechanic.id, card_id: new_card.id)
        end

    else
        vanilla = Mechanic.find_by(name: "Vanilla")
        vanilla ||= Mechanic.create(name: "Vanilla")
        CardMechanic.create(mechanic_id: vanilla.id , card_id: new_card.id)
    end

      new_card.card_set_id = my_set.id
      new_card.save
    end
  end

end

Mechanic.all.each do |mechanic|
  mechanic.update(name: mechanic.name.downcase)
end
Mechanic.find_by(name: "adapt").update(description: "Choose from one of three possible upgrades to the possessing minion.")
Mechanic.find_by(name: "battlecry").update(descrition: "Activates when played from the hand.")
Mechanic.find_by(name: "casts when drawn").update(description: "The spell card is automatically cast for no mana when drawn from your deck, and the next card in the deck is then drawn. Only found on a few Uncollectible spells.")
Mechanic.find_by(name: "charge").update(description: "Enables the minion to attack on the same turn that it is summoned.")
Mechanic.find_by(name: "choose one").update(description: "Gives the controlling player the ability to choose between two or more effects stated in the card. Found only on druid cards.")
Mechanic.find_by(name: "divine shield").update(description: "")
Mechanic.find_by(name: "combo").update(description: "Has an effect that activates when played from hand, after you've played at least one card this turn.")
Mechanic.find_by(name: "lifesteal").update(description: "When damage is dealt, it heals the owners hero.")
Mechanic.find_by(name: "inspire").update(description: "When you use a hero power with an Inspire minion on your side of the board, activate the effect.")
Mechanic.find_by(name: "overkill").update(description: "When you attack and kill a minion, and there is more than enough damage on the killing blow, activate the effect.")
Mechanic.find_by(name: "overload").update(description: "Activated when the card is played from the hand, at the price of reduced mana next turn.")
Mechanic.find_by(name: "poisonous").update(description: "Instantly kills whatever minion it hits, with the exception of Divine Shield.")
Mechanic.find_by(name: "quest").update(description: "A (1) cost spell that has a delayed effect, which is worked up to throughout the course of the game.  When completed, they have a specific reward.")
Mechanic.find_by(name: "reborn").update(description: "When destroyed, return this minion to life with (1) hp and remove the Reborn effect")
Mechanic.find_by(name: "recruit").update(description: "Instantly play a card from your deck, it does not trigger Battlecries")
Mechanic.find_by(name: "rush").update(description: "Can instantly attack minions on the board.")
Mechanic.find_by(name: "secret").update(description: "A spell that is activated when your opponent takes a specific action.")
Mechanic.find_by(name: "silence").update(description: "Remove all buffs and effects on a minion on the board")
Mechanic.find_by(name: "spell damage").update(description: "Increase the damage of spells cast")
Mechanic.find_by(name: "taunt").update(description: "Enemy minions must attack a Taunt minion if present")
Mechanic.find_by(name: "twinspell").update(description: "After casting a Twinspell, add a copy of the original spell to you hand (without the Twinspell keyword).")
Mechanic.find_by(name: "windfury").update(description: "A Windfury minion can attack twice per turn")
Mechanic.find_by(name: "jade golem").update(description: "Summons a (1/1) Jade Golem minion.  The more Jade cards are played, the larger the base-stats on the following Jade Golems become.")
Mechanic.find_by(name: "freeze").update(description: "A frozen character cannot attack this turn.")
Mechanic.find_by(name: "echo").update(description: "A card that can be played multiple times from the hand, if the user has enough mana.")
Mechanic.find_by(name: "deathrattle").update(description: "An effect that activates when a minion is destoyed, or otherwise triggered by another card")
Mechanic.find_by(name: "").update(description: "")


# untested
p ">> Deleting Useless Card Data"
p ">>> Checking for Mechanically Named Cards (ex: 'Battlecry' , 'Rush')"
Mechanic.all.each do |mechanic|
  Card.all.each do |card|
    if(card.name == mechanic.name)
      p "Deleting #{card.name} from set: #{card.card_set.name}"
      Card.find_by(id: card.id).delete
    else next
    end
  end
end

p ">> Adjusting Cardset Data"
# Adding Years and Standard-Play to CardSets
CardSet.find_by(name: 'Basic').update(year: 2014, standard: true)
CardSet.find_by(name: 'Classic').update(year: 2014, standard: true)
CardSet.find_by(name: 'Hall of Fame').update(year: 2014, standard: false)
CardSet.find_by(name: 'Naxxramas').update(year: 2014, standard: false)
CardSet.find_by(name: 'Goblins vs Gnomes').update(year: 2014, standard: false)
CardSet.find_by(name: 'Blackrock Mountain').update(year: 2015, standard: false)
CardSet.find_by(name: 'The Grand Tournament').update(year: 2015, standard: false)
CardSet.find_by(name: 'The League of Explorers').update(year: 2015, standard: false)
CardSet.find_by(name: 'Whispers of the Old Gods').update(year: 2016, standard: false)
CardSet.find_by(name: 'One Night in Karazhan').update(year: 2016, standard: false)
CardSet.find_by(name: 'Mean Streets of Gadgetzan').update(year: 2016, standard: false)
CardSet.find_by(name: "Journey to Un'Goro").update(year: 2017, standard: false)
CardSet.find_by(name: 'Knights of the Frozen Throne').update(year: 2017, standard: false)
CardSet.find_by(name: 'Kobolds & Catacombs').update(year: 2017, standard: false)
CardSet.find_by(name: 'The Witchwood').update(year: 2018, standard: true)
CardSet.find_by(name: 'The Boomsday Project').update(year: 2018, standard: true)
CardSet.find_by(name: "Rastakhan's Rumble").update(year: 2018, standard: true)
CardSet.find_by(name: 'Rise of Shadows').update(year: 2019, standard: true)
CardSet.find_by(name: 'Saviors of Uldum').update(year: 2019, standard: true)
CardSet.find_by(name: 'Descent of Dragons').update(year: 2019, standard: true)
CardSet.find_by(name: 'Wild Event').update(year: 2019, standard: true)

# Manual Setup for DeckBuilding
p ">> Setting Up PlayerClass DBFID's"
PlayerClass.find_by(name: "Mage").update(dbf_id: 637)
PlayerClass.find_by(name: "Warrior").update(dbf_id: 7)
PlayerClass.find_by(name: "Hunter").update(dbf_id: 31)
PlayerClass.find_by(name: "Shaman").update(dbf_id: 1066)
PlayerClass.find_by(name: "Priest").update(dbf_id: 813)
PlayerClass.find_by(name: "Paladin").update(dbf_id: 671)
PlayerClass.find_by(name: "Warlock").update(dbf_id: 893)
PlayerClass.find_by(name: "Druid").update(dbf_id: 274)
PlayerClass.find_by(name: "Rogue").update(dbf_id: 930)

# Generate Synergies in Standard Cards