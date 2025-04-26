class ApplicationMailer < ActionMailer::Base
  default(
    from: Rails.application.credentials.dig(:smtp, :from) || "notes@notes.app"
  )
  layout "mailer"
end
