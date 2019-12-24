class MechanicSerializer
  include FastJsonapi::ObjectSerializer
  attributes(
    :name,
    :tribe_id,
    :is_buff,
  )
  belongs_to :tribe , serializer: TribeSerializer , optional: true
end
