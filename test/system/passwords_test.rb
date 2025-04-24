require "application_system_test_case"

class PasswordsTest < ApplicationSystemTestCase
  test "forgot password page" do
    visit new_password_url

    assert_title "Forgot your password?"
    assert_selector "h1", text: "Forgot your password?"
    assert_field "Email address",
      type: "email",
      placeholder: "Enter your email address"
    assert_button "Email reset instructions"

    assert_link "Sign in instead", href: new_session_path
  end

  test "forgot password submission" do
    visit new_password_url

    fill_in "Email address", with: "test@email.com"
    click_button "Email reset instructions"

    assert_text "Password reset instructions sent if that user exists."
    assert_current_path new_session_path
  end

  test "reset password from email link page" do
    visit edit_password_url(users(:one).password_reset_token)

    assert_title "Update your password"
    assert_selector "h1", text: "Update your password"
    assert_field "Password",
      type: "password",
      placeholder: "Enter new password"
    assert_field "Password confirmation",
      type: "password",
      placeholder: "Repeat new password"
    assert_button "Save"
  end

  test "reset password from email link with matching passwords" do
    visit edit_password_url(users(:one).password_reset_token)

    fill_in "Password", with: "new password"
    fill_in "Password confirmation", with: "new password"
    click_button "Save"

    assert_text "Password has been reset."
    assert_current_path new_session_path
  end

  test "reset password from email link without matching passwords" do
    freeze_time

    visit edit_password_url(users(:one).password_reset_token)

    fill_in "Password", with: "new password"
    fill_in "Password confirmation", with: "old password"
    click_button "Save"

    assert_text "Passwords did not match."
    assert_current_path edit_password_url(users(:one).password_reset_token)
  end
end
