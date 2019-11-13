# frozen_string_literal: true

require 'uri'
require 'net/http'
require 'openssl'

skip_fetch = false # Set this to false when you need to fetch
if skip_fetch == false
  puts 'Fetching Card Data <<<<<<'
  url = URI('https://omgvamp-hearthstone-v1.p.rapidapi.com/cards')

  http = Net::HTTP.new(url.host, url.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE

  request = Net::HTTP::Get.new(url)
  request['x-rapidapi-host'] = 'omgvamp-hearthstone-v1.p.rapidapi.com'
  request['x-rapidapi-key'] = 'c15502ebd8msh183a4fdd23c6591p1954c4jsn302be1511f5b'

  response = http.request(request)
  puts 'PARSING JSON <<<<<<<<<'
  data = JSON.parse(response.read_body)

  data.each do |_card_set_name, set_data|
    p "Creating #{_card_set_name}"
    my_set = CardSet.create(name: _card_set_name)
    set_data.each do |card|
      new_card = Card.new
      new_card.name = card['name']
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
      card_type = case card
      when card['health'] != nil && card['attack'] != nil
        return "Minion"
      when card['durability'] != nil && card['attack'] != nil
        return "Weapon"
      else
        return "Spell"
      end
      new_card.card_type = card_type
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
            p "Creating Mechanic: #{m_name}"
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

#Keyword Generation
# KeyWord.create(word: "")

# Generate Synergies in Standard Cards