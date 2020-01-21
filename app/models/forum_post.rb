class ForumPost < ApplicationRecord
    belongs_to :forum
    belongs_to :user

    has_many :post_upvotes
    has_manny :upvotes , through: :post_upvotes
end
