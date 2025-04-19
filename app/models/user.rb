class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :notes, dependent: :destroy

  normalizes :email_address, with: -> e { e.strip.downcase }
end
