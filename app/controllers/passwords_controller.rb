class PasswordsController < ApplicationController
  allow_unauthenticated_access
  before_action :set_user_by_token, only: %i[edit update]
  rate_limit to: 5, within: 10.minutes, only: %i[create update], with: -> do
    redirect_to new_session_url, alert: t("shared.rate_limit_try_again_later")
  end

  def new
  end

  def edit
  end

  def create
    if user = User.find_by(email_address: params[:email_address])
      PasswordsMailer.reset(user).deliver_later
    end

    redirect_to new_session_path, notice: t(".success")
  end

  def update
    if @user.update(params.permit(:password, :password_confirmation))
      redirect_to new_session_path, notice: t(".success")
    else
      redirect_to edit_password_path(params[:token]), alert: t(".failure")
    end
  end

  private

  def set_user_by_token
    @user = User.find_by_password_reset_token!(params[:token])
  rescue ActiveSupport::MessageVerifier::InvalidSignature
    redirect_to new_password_path, alert: t("passwords.invalid_reset_link")
  end
end
