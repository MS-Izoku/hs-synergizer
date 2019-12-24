class DeckSerializer
  include FastJsonapi::ObjectSerializer
  attributes(
    :name ,
    :deck_code
  )
  belongs_to :player_class , serializer: PlayerClassSerializer
end
