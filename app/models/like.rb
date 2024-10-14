class Like < ApplicationRecord
    belongs_to :user_like, class_name: "User"
    belongs_to :micropost_like, class_name: "Micropost"
    validates :user_like_id, presence: true
    validates :micropost_like_id, presence: true
end
