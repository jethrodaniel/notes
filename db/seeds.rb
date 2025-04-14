user = User.create!(
  email_address: 'admin@example.com',
  password: 'password'
)

20.times do
  content = Faker::Lorem.paragraph(sentence_count: rand(1..8))
  Note.create!(user:, content:)
end
