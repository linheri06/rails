class Message < ApplicationRecord
    belongs_to :send, class_name: "User"
    belongs_to :receive, class_name: "User"
    validates :send_id, presence: true
    validates :receive_id, presence: true
end
