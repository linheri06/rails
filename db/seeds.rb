# # Create a main sample user.
# User.create!(name: "Example User",
#             email: "example@railstutorial.org",
#             password: "foobar",
#             password_confirmation: "foobar",
#             admin: true,
#             activated: true,
#             activated_at: Time.zone.now)
# # Generate a bunch of additional users.
# 99.times do |n|
#     name = "name#{n}"
#     email = "example#{n}@railstutorial.org"
#     password = "password"
#     User.create!(name: Faker::Name.unique.name,
#                 email: email,
#                 password: password,
#                 password_confirmation: password,
#                 admin: false,
#                 activated: true,
#                 activated_at: Time.zone.now)
# end

# users = User.order(:created_at).take(60)
# 10.times do
#     content = Faker::Lorem.sentence(word_count: 10)
#     users.each { |user| user.microposts.create!(content: content) }
# end

# Create following relationships.
# users = User.all
# user = users.first
# following = users[2..10]
# followers = users[3..10]
# following.each { |followed| user.follow(followed) }
# followers.each { |follower| follower.follow(user) }


# users = User.all
# user = users.first
# microposts = Micropost.all
# user_like = users[2..10]
# micropost_like = microposts[3..40]
# user_like.each { |user| user.like(Micropost.find(1)) }
# micropost_like.each { |mic| user.like(mic) }

#Create following relationships.

20.times do |n|
    send = Faker::Number.rand(12)
    receive = 13
    content =Faker::Lorem.sentence(word_count: 10)
    Message.create!(send,receive,contents)
end

