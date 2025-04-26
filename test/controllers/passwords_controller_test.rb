require "test_helper"

class PasswordsControllerTest < ActionDispatch::IntegrationTest
  test "#new" do
    get new_password_url

    assert_response :success
  end

  test "#edit with valid token" do
    get edit_password_path(users(:one).password_reset_token)

    assert_response :success
  end

  test "#edit with invalid token" do
    get edit_password_path("invalid token")

    assert_redirected_to new_password_path
  end

  test "#edit with expired token" do
    freeze_time

    token = users(:one).password_reset_token

    travel_to 15.minutes.from_now

    get edit_password_path(token)

    assert_redirected_to new_password_path
    assert_equal "Password reset link is invalid or has expired.", flash[:alert]
  end

  test "#create with valid email" do
    user = users(:one)

    assert_enqueued_email_with PasswordsMailer, :reset, args: user do
      post passwords_url, params: {email_address: user.email_address}
    end
    assert_redirected_to new_session_url

    assert_equal(
      "Password reset instructions sent.",
      flash[:notice]
    )
  end

  test "#create with invalid email" do
    assert_no_enqueued_emails do
      post passwords_url, params: {email_address: "not@present.user"}
    end
    assert_redirected_to new_session_url
    assert_equal(
      "Password reset instructions sent.",
      flash[:notice]
    )
  end

  test "#update with valid user, password and confirmation" do
    user = users(:one)
    token = user.password_reset_token
    new_password = "new-password"

    put password_path(token), params: {
      password: new_password,
      password_confirmation: new_password
    }

    assert_redirected_to new_session_url
    assert_equal "Password has been reset.", flash[:notice]
  end

  test "#update with expired link" do
    freeze_time

    user = users(:one)
    token = user.password_reset_token
    new_password = "new-password"

    travel_to 15.minutes.from_now

    put password_path(token), params: {
      password: new_password,
      password_confirmation: new_password
    }

    assert_redirected_to new_password_path
    assert_equal "Password reset link is invalid or has expired.", flash[:alert]
  end

  test "#update with valid user, but non-matching password and confirmation" do
    user = users(:one)
    token = user.password_reset_token
    new_password = "new-password"

    put password_path(token), params: {
      password: new_password,
      password_confirmation: "old-password"
    }

    assert_redirected_to edit_password_path(token)
    assert_equal "Passwords did not match.", flash[:alert]
  end

  test "#update with invalid user" do
    put password_path("invalid token")

    assert_redirected_to new_password_path
    assert_equal "Password reset link is invalid or has expired.", flash[:alert]
  end
end
