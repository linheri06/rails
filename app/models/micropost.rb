class Micropost < ApplicationRecord
  belongs_to :user
  default_scope -> { order(created_at: :desc) }
  has_one_attached :image
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 250 }

  has_many :active_micropost_likes, class_name: "Like",
                                    foreign_key: "micropost_like_id"  ,
                                    dependent: :destroy
  has_many :micropost_liking, through: :active_micropost_likes, source: :user_like

  def unlike(other_user)
    micropost_liking.delete(other_user)
  end

  def display_image
   
    
  end
end
