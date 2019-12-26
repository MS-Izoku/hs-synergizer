class CardSetSerializer
  include FastJsonapi::ObjectSerializer
  attributes(
    :name,
    :year,
    :standard
  )

  has_many :cards , serializer: CardSerializer
end
