class PreferencesController < ApplicationController
  before_action :set_preferences, only: %i[edit update]

  def show
  end

  def edit
  end

  def update
    if @preferences.update(preference_params)
      redirect_to preferences_path,
        notice: t(".success", locale: Current.user.preferences.language),
        status: :see_other
    else
      render :edit, status: :unprocessable_content
    end
  end

  private

  def set_preferences
    @preferences = Current.user.preferences
  end

  def preference_params
    params.expect(preferences: [:language, :note_index_truncate_length])
  end
end
