# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
user = User.find_by(email_address: ENV.fetch('EXAMPLE_USER_EMAIL')) ||
  User.create!(
  email_address: ENV.fetch('EXAMPLE_USER_EMAIL'),
  password: ENV.fetch('EXAMPLE_USER_PASSWORD')
)

20.times do
  content = Faker::Lorem.paragraph(sentence_count: rand(1..8))
  Note.create!(user:, content:)
end
