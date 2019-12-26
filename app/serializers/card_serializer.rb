class CardSerializer
  include FastJsonapi::ObjectSerializer
  attributes( 
     :name ,
     :card_text , 
     :flavor_text , 
     :card_type , 
     :cost , 
     :attack , 
     :health , 
     :durability , 
     :elite , 
     :img , 
     :img_gold , 
     :dbf_id , 
     :dust_cost
    )
  belongs_to :card_set , serializer: CardSetSerializer
  belongs_to :player_class , serializer: PlayerClassSerializer
end
