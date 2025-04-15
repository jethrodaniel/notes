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

  test "click forgot password" do
    visit new_password_url

    fill_in "Email address", with: "test@email.com"
    click_button "Email reset instructions"

    assert_text "Password reset instructions sent if that user exists."
    assert_current_path new_session_path
  end
end
