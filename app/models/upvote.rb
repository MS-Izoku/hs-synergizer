class Upvote < ApplicationRecord
  belongs_to :upvotable, polymorphic: true
end
