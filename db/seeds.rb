User.destroy_all

user = User.create!(
  email_address: "admin@example.com",
  password: "password"
)

quote = Faker::Quote.unique

loop do
  content = quote.mitch_hedberg
  Note.create!(user:, content:)
rescue Faker::UniqueGenerator::RetryLimitExceeded
  break
end
