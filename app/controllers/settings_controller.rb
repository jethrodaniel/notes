class SettingsController < ApplicationController
  def index
  end

  def update
    respond_to do |format|
      if Current.user.update(settings_params)
        format.html do
          redirect_to settings_path,
            notice: t(".success", locale: Current.user.language),
            status: :see_other
        end
      else
        format.html { render :index, status: :unprocessable_entity }
      end
    end
  end

  private

  def settings_params
    params.expect(user: [:language])
  end
end
