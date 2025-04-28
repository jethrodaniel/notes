require "test_helper"

class PasswordsMailerTest < ActionMailer::TestCase
  test "reset" do
    freeze_time
    token = users(:one).password_reset_token
    link = "http://example.com/passwords/#{token}/edit"

    email = PasswordsMailer.reset users(:one)

    assert_equal ["notes@notes.app"], email.from
    assert_equal [users(:one).email_address], email.to
    assert_equal "Reset your password", email.subject

    assert_includes email.text_part.to_s,
      "You can reset your password within the next 15 minutes on " \
      "this password reset page:\r\n#{link}"

    assert_includes email.html_part.to_s,
      "You can reset your password within the next 15 minutes on " \
      "<a href=\"#{link}\">this password reset page</a>."
  end
end
