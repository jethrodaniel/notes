module PreferencesHelper
  def language_options_for_select
    Rails.application.config.i18n.available_locales.map do |locale|
      # NOTE: i18n-tasks sees these as unused keys if we use `scope` here
      [t("preferences.language_options.#{locale}"), locale]
    end
  end
end
