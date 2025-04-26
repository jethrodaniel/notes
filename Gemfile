source "https://rubygems.org"

ruby file: ".tool-versions"

gem "rails", "~> 8.0.2"
gem "propshaft"
gem "sqlite3", ">= 2.1"
gem "puma", ">= 5.0"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "tailwindcss-rails"
gem "bcrypt", "~> 3.1.7"

gem "tzinfo-data", platforms: %i[windows jruby]

gem "solid_cache"
gem "solid_queue"
gem "solid_cable"

gem "bootsnap", require: false
# Use non-git when https://github.com/basecamp/kamal/pull/1499 is released
gem "kamal", require: false, github: "basecamp/kamal"
gem "thruster", require: false

gem "sqlite_extensions-uuid", github: "jethrodaniel/sqlite_extensions-uuid"

group :development, :test do
  gem "debug", platforms: %i[mri windows], require: "debug/prelude"
  gem "brakeman", require: false
  gem "rubocop-lazy-config",
    github: "jethrodaniel/rubocop-lazy-config",
    require: false
end

group :development do
  gem "web-console"
  gem "faker"
  gem "i18n-tasks", "~> 1.0.15", require: false
end

group :test do
  gem "capybara"
  gem "cuprite"
  gem "selenium-webdriver"
end
