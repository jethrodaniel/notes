class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :notes, dependent: :destroy
  has_one :preferences, dependent: :destroy

  after_create :create_preferences!

  normalizes :email_address, with: -> e { e.strip.downcase }

  def create_preferences!
    build_preferences(language: :en).save!
  end
end
