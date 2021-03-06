# frozen_string_literal: true

require 'uri'
require 'net/http'
require 'openssl'
require 'pry'
require 'pretty_json'

skip_fetch = false # Set this to false when you need to fetch
show_creation_in_console = false

if skip_fetch == false
  User.create(username: 'cornjulio', password: 'password', email: 'email@gmail.com')

  # creating special-case card sets
  CardSet.create(name: 'Hall of Fame', standard: false)
  CardSet.create(name: "Removed" , standard: false)


  Mechanic.create(name: 'Summon')
  Mechanic.create(name: 'Choose One')
  Mechanic.create(name: 'Passive')
  Mechanic.create(name: 'Start of Game', description: 'Activates when the game starts, after your starting mulligan.')

  puts 'Fetching Card Data <<<<<<'

  url = URI('https://omgvamp-hearthstone-v1.p.rapidapi.com/cards')

  http = Net::HTTP.new(url.host, url.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE

  request = Net::HTTP::Get.new(url)
  request['x-rapidapi-host'] = 'omgvamp-hearthstone-v1.p.rapidapi.com'
  request['x-rapidapi-key'] = 'c15502ebd8msh183a4fdd23c6591p1954c4jsn302be1511f5b'

  response = http.request(request)

  data = JSON.parse(response.read_body)

  data.each do |_card_set_name, set_data|
    my_set = CardSet.create(name: _card_set_name)
    p "(CardSet)> Creating Set: #{my_set.name}"
    set_data.each do |card|
      new_card = Card.create
      new_card.name = card['name']
      p "(Card: #{new_card.name})>> Creating Card: #{new_card.name}"
      new_card.dbf_id = card['dbfId']

      new_card.cost = card['cost'].to_i
      new_card.health = card['health'].to_i
      new_card.attack = card['attack'].to_i
      new_card.armor = card['armor'].to_i

      pc_name = card['playerClass']
      pc_name = 'Neutral' if card['playerClass'].nil?
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

      new_card[:collectable] = card['collectable']

      new_card.card_text = card['text']
      new_card.flavor_text = card['flavor']

      new_card.img = card['img']
      new_card.img_gold = card['imgGold']

      new_card.durability = card['durability']
      my_artist = Artist.find_by(name: card['artist'])
      my_artist ||= Artist.create(name: card['artist'])
      new_card.artist_id = my_artist.id

      case card
      when !card['health'].nil? && !card['attack'].nil?
        new_card.card_type 'Minion'
      when !card['durability'].nil? && !card['attack'].nil?
        new_card.card_type 'Weapon'
      else
        new_card.card_type = 'Spell'
      end
      p ">>>> Set Card Type to: #{new_card.card_type}" if show_creation_in_console

      # <<<<<< MECHANICS SECTION
      if card['mechanics']
        mechanics = card['mechanics'][0] # this line needs to change, check the structure of each one if need be
        mechanics.each do |_key, mechanic|
          temp_mechanic = Mechanic.find_by(name: mechanic)
          if temp_mechanic.nil?
            temp_mechanic = Mechanic.create(name: mechanic)
            p "(Mechanic)>>> Creating New Mechanic: #{temp_mechanic.name}"
          end

          new_card_mechanic = CardMechanic.create(mechanic_id: temp_mechanic.id, card_id: new_card.id)
          p "(Card-Mechanic)>>> Creating new Card Mechanic with Card##{new_card.id}(#{new_card.name}) and Mechanic##{temp_mechanic.id} (#{temp_mechanic.name})"
        end

      else
        vanilla = Mechanic.find_by(name: 'Vanilla')
        vanilla ||= Mechanic.create(name: 'Vanilla')
        CardMechanic.create(mechanic_id: vanilla.id, card_id: new_card.id)
        p "(Card-Mechanic)>>> #{new_card.name} is Vanilla"
    end

      new_card.card_set_id = my_set.id
      new_card.save
    end
  end
end

p 'Initial Seed Complete'
p '(Card)>>> Initializing Card Keyword Parsing'
Card.all.each do |card|
  plain_text = card.plain_text
  Mechanic.all.each do |mechanic|
    next unless plain_text.include?(mechanic.name)
    next if CardMechanic.find_by(mechanic_id: mechanic.id, card_id: card.id)

    CardMechanic.create(mechanic_id: mechanic.id, card_id: card.id)
    p "(Card)>>> Linking --#{mechanic.name}-- to: #{card.name}"
  end
end

# default descriptions from the Hearthstone Wiki
Mechanic.all.each do |mechanic|
  mechanic.update(name: mechanic.name.downcase)
end
Mechanic.find_by(name: 'adapt').update(description: 'Choose from one of three possible upgrades to the possessing minion.')
Mechanic.find_by(name: 'battlecry').update(description: 'Activates when played from the hand.')
Mechanic.find_by(name: 'casts when drawn').update(description: 'The spell card is automatically cast for no mana when drawn from your deck, and the next card in the deck is then drawn. Only found on a few Uncollectible spells.')
Mechanic.find_by(name: 'charge').update(description: 'Enables the minion to attack on the same turn that it is summoned.')
Mechanic.find_by(name: 'choose one').update(description: 'Gives the controlling player the ability to choose between two or more effects stated in the card. Found only on druid cards.')
Mechanic.find_by(name: 'divine shield').update(description: 'Absorbs a single tick of damage, no matter how large, then is removed.  Minions with divine shield does not trigger Poisonous during damage calculations.')
Mechanic.find_by(name: 'combo').update(description: "Has an effect that activates when played from hand, after you've played at least one card this turn.")
Mechanic.find_by(name: 'lifesteal').update(description: 'When damage is dealt, it heals the owners hero.')
Mechanic.find_by(name: 'inspire').update(description: 'When you use a hero power with an Inspire minion on your side of the board, activate the effect.')
Mechanic.find_by(name: 'overkill').update(description: 'When you attack and kill a minion, and there is more than enough damage on the killing blow, activate the effect.')
Mechanic.find_by(name: 'overload').update(description: 'Activated when the card is played from the hand, at the price of reduced mana next turn.')
Mechanic.find_by(name: 'poisonous').update(description: 'Instantly kills whatever minion it hits, with the exception of Divine Shield.')
Mechanic.find_by(name: 'quest').update(description: 'A (1) cost spell that has a delayed effect, which is worked up to throughout the course of the game.  When completed, they have a specific reward.')
Mechanic.find_by(name: 'reborn').update(description: 'When destroyed, return this minion to life with (1) hp and remove the Reborn effect')
Mechanic.find_by(name: 'recruit').update(description: 'Instantly play a card from your deck, it does not trigger Battlecries')
Mechanic.find_by(name: 'rush').update(description: 'Can instantly attack minions on the board.')
Mechanic.find_by(name: 'secret').update(description: 'A spell that is activated when your opponent takes a specific action.')
Mechanic.find_by(name: 'silence').update(description: 'Remove all buffs and effects on a minion on the board')
Mechanic.find_by(name: 'spell damage').update(description: 'Increase the damage of spells cast')
Mechanic.find_by(name: 'taunt').update(description: 'Enemy minions must attack a Taunt minion if present')
Mechanic.find_by(name: 'twinspell').update(description: 'After casting a Twinspell, add a copy of the original spell to you hand (without the Twinspell keyword).')
Mechanic.find_by(name: 'windfury').update(description: 'A Windfury minion can attack twice per turn')
Mechanic.find_by(name: 'jade golem').update(description: 'Summons a (1/1) Jade Golem minion.  The more Jade cards are played, the larger the base-stats on the following Jade Golems become.')
Mechanic.find_by(name: 'freeze').update(description: 'A frozen character cannot attack this turn.')
Mechanic.find_by(name: 'echo').update(description: 'A card that can be played multiple times from the hand, if the user has enough mana.')
Mechanic.find_by(name: 'deathrattle').update(description: 'An effect that activates when a minion is destoyed, or otherwise triggered by another card')

# deleting useless card data post-fetch
p '>> Deleting Useless Card Data'
p ">>> Checking for Mechanically Named Cards (ex: 'Battlecry' , 'Rush')"
Mechanic.all.each do |mechanic|
  Card.all.each do |card|
    if card.name == mechanic.name
      p "Deleting #{card.name} from set: #{card.card_set.name}"
      Card.find_by(id: card.id).delete
    else next
    end
  end
end

# Moving NYI / Token Cards out of Sets

p 'Removing Token , NYI , and (Basic) Hero Cards'
token_set = CardSet.create(name: 'Token', standard: false)
nyi_set = CardSet.create(name: 'NYI', standard: false)
heroes_set = CardSet.create(name: 'Hero Classes', standard: false)

tokens = ['Treant', 'Silver Hand Recruit', "Token"]
nyi_cards = ['Avatar of the Coin']
hero_cards = [1066, 813, 671, 7, 31, 274, 893, 637, 930]

Card.where(name: tokens).update_all(card_set_id: token_set.id, collectable: false)
Card.where(name: nyi_cards).update_all(card_set_id: nyi_set.id, collectable: false)
Card.where(dbf_id: hero_cards).update_all(card_set_id: heroes_set.id, collectable: false)

# getting rid of cards we no longer need
CardSet.move_cards_to_set('Removed', CardSet.removed_cards)
CardSet.move_cards_to_set('Hall of Fame', CardSet.hall_of_fame)

# deleting those useless cards from the db
# HoF is still in tact, but will not be considered standard
p ">>> Deleting Useless Cards (CardSet method)"
CardSet.delete_useless_cards

p '>> Adjusting Cardset Data'

# Adding Years and Standard-Play to CardSets
CardSet.find_by(name: 'Basic').update(year: 2014)
CardSet.find_by(name: 'Classic').update(year: 2014)
CardSet.find_by(name: 'Hall of Fame').update(year: 2014)
CardSet.find_by(name: 'Naxxramas').update(year: 2014)
CardSet.find_by(name: 'Goblins vs Gnomes').update(year: 2014)
CardSet.find_by(name: 'Blackrock Mountain').update(year: 2015)
CardSet.find_by(name: 'The Grand Tournament').update(year: 2015)
CardSet.find_by(name: 'The League of Explorers').update(year: 2015)
CardSet.find_by(name: 'Whispers of the Old Gods').update(year: 2016)
CardSet.find_by(name: 'One Night in Karazhan').update(year: 2016)
CardSet.find_by(name: 'Mean Streets of Gadgetzan').update(year: 2016)
CardSet.find_by(name: "Journey to Un'Goro").update(year: 2017)
CardSet.find_by(name: 'Knights of the Frozen Throne').update(year: 2017)
CardSet.find_by(name: 'Kobolds & Catacombs').update(year: 2017)
CardSet.find_by(name: 'The Witchwood').update(year: 2018)
CardSet.find_by(name: 'The Boomsday Project').update(year: 2018)
CardSet.find_by(name: "Rastakhan's Rumble").update(year: 2018)
CardSet.find_by(name: 'Rise of Shadows').update(year: 2019)
CardSet.find_by(name: 'Saviors of Uldum').update(year: 2019)
CardSet.find_by(name: 'Descent of Dragons').update(year: 2019)
CardSet.find_by(name: 'Wild Event').update(year: 2019)

CardSet.all.each do |set|
  is_standard = true
  if !set.year
    is_standard = false
  else
    unless set.year >= Date.current.year - 1 && (set.name == 'Basic' || set.name == 'Classic')
      is_standard = false
    end
  end
  set.update(standard: is_standard)
  p "(CardSet)>>> Setting #{set.name} to #{set.standard ? 'standard' : 'wild'}"
end

# Manual Setup for DeckBuilding
p ">> Setting Up PlayerClass DBFID's"
PlayerClass.find_by(name: 'Mage').update(dbf_id: 637)
PlayerClass.find_by(name: 'Warrior').update(dbf_id: 7)
PlayerClass.find_by(name: 'Hunter').update(dbf_id: 31)
PlayerClass.find_by(name: 'Shaman').update(dbf_id: 1066)
PlayerClass.find_by(name: 'Priest').update(dbf_id: 813)
PlayerClass.find_by(name: 'Paladin').update(dbf_id: 671)
PlayerClass.find_by(name: 'Warlock').update(dbf_id: 893)
PlayerClass.find_by(name: 'Druid').update(dbf_id: 274)
PlayerClass.find_by(name: 'Rogue').update(dbf_id: 930)



# Generate Synergies in Standard Cards
