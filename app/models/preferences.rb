class Preferences < ApplicationRecord
  belongs_to :user

  validates :language,
    inclusion: Rails.application.config.i18n.available_locales

  validates :note_index_truncate_length,
    presence: true,
    numericality: {only_integer: true, greater_than: 0}
end
