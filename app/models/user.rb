class User < ApplicationRecord
    # :name, :email
    #has_secure_password

    attr_accessor :remember_token, :activation_token, :reset_token
    before_save :downcase_email
    before_create :create_activation_digest
    validates :name, presence: true, length: { maximum: 50 }
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates :email, presence: true, length: { maximum: 255 },
    format: { with: VALID_EMAIL_REGEX },
    uniqueness: true
    has_secure_password
    validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

    has_many :microposts, dependent: :destroy

    has_many :active_relationships, class_name: "Relationship",
                                    foreign_key: "follower_id"  ,
                                    dependent: :destroy
    has_many :following, through: :active_relationships, source: :followed
    has_many :passive_relationships, class_name: "Relationship",
                                    foreign_key: "followed_id",
                                    dependent: :destroy  
    has_many :followers, through: :passive_relationships, source: :follower             

    has_many :active_likes, class_name: "Like",
                            foreign_key: "user_like_id"  ,
                            dependent: :destroy
    has_many :liking, through: :active_likes, source: :micropost_like

    has_many :active_send, class_name: "Message",
                                    foreign_key: "send_id"  ,
                                    dependent: :destroy
    has_many :sending, through: :active_send, source: :send
    has_many :active_receive, class_name: "Message",
                                    foreign_key: "receive_id",
                                    dependent: :destroy  
    has_many :receiving, through: :active_receive, source: :receive           

    def User.new_token
        SecureRandom.urlsafe_base64
    end

    # Sets the password reset attributes
    def create_reset_digest
        self.reset_token = User.new_token
        update_attribute(:reset_digest, User.digest(reset_token))
        update_attribute(:reset_sent_at, Time.zone.now)
    end

    # Sends password reset email.
    def send_password_reset_email
        UserMailer.password_reset(self).deliver_now
    end


    def self.digest(string)
        cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                      BCrypt::Engine.cost
        BCrypt::Password.create(string, cost: cost)
    end

    def remember
        self.remember_token = User.new_token
        update_attribute(:remember_digest, User.digest(remember_token))
    end

    # Returns true if a password reset has expired.
    def password_reset_expired?
        reset_sent_at < 2.hours.ago
    end

    # Returns true if the given token matches the digest.
    def authenticated?(attribute, token)
        digest = self.send("#{attribute}_digest")
        return false if digest.nil?
        BCrypt::Password.new(digest).is_password?(token)
    end

    def forget
        update_attribute(:remember_digest, nil)
    end

    def downcase_email
        self.email = email.downcase
    end

    def create_activation_digest
        self.activation_token = User.new_token
        self.activation_digest = User.digest(activation_token)
    end

    def follow(other_user)
        following << other_user
    end

    def unfollow(other_user)
        following.delete(other_user)
    end

    def following? (other_user)
        following.include?(other_user)
    end

    def feed
        following_ids = "SELECT followed_id FROM relationships WHERE follower_id = :user_id"
        Micropost.where("user_id IN (#{following_ids}) OR user_id = :user_id", user_id: id)
        #binding.pry
    end

    def like(other_micropost)
        liking << other_micropost
    end

    def liking? (other_micropost)
        liking.include?(other_micropost)
    end

    def sending(message)
        sending << message
    end

    def liking? (message)
        liking.include?(message)
    end

    def sleepppp(n)
        (1..n).each do |i|
            sleep(1)
            puts n-i
        end
    end


end
