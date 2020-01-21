class ForumThread < ApplicationRecord
    belongs_to :user, class_name: :user , foreign_key: "op_id"
    has_many :user_posts
    has_many :users , through: :user_posts

    has_many :thread_upvotes
    has_many :upvotes, through: :thread_upvotes
end
