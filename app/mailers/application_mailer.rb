class ApplicationMailer < ActionMailer::Base
  default from: Rails.env.test? \
    ? "notes@notes.app"
    : Rails.application.credentials.dig(:smtp, :from)
  layout "mailer"
end
