User.destroy_all

user = User.create!(
  email_address: "admin@example.com",
  password: "password"
)

generators = [
  -> { Faker::Quotes::Shakespeare.hamlet_quote + "\n\n- Hamlet" },
  -> { Faker::Quote.mitch_hedberg + "\n\n- Mitch Hedberg" },
  -> { Faker::Quote.matz + "\n\n- Matz" },
  -> { Faker::Books::Dune.quote + "\n\n- Dune" },
  -> { Faker::JapaneseMedia::CowboyBebop.quote + "\n\n- Cowboy Bebop" }
]

attrs = 1_000.times.flat_map { generators.map(&:call) }.shuffle.map do |content|
  {
    content:,
    user_id: user.id
  }
end

Note.insert_all(attrs)
