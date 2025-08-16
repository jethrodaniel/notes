class Preferences < ApplicationRecord
  belongs_to :user

  validates :language,
    inclusion: Rails.application.config.i18n.available_locales
end
