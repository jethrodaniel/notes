require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "#new" do
    get new_session_path

    assert_response :success
  end

  test "#create with valid user and password" do
    assert_difference("Session.count", 1) do
      post session_url, params: {
        email_address: users(:one).email_address,
        password: "password"
      }
    end

    assert_redirected_to root_url
  end

  test "#create with invalid password" do
    post session_url, params: {
      email_address: users(:one).email_address,
      password: "incorrect"
    }

    assert_equal "Try another email address or password.", flash[:alert]
    assert_redirected_to new_session_url
  end

  test "#create is rate limited" do
    skip "figure out how best to test this"
  end

  test "#destroy" do
    post session_url, params: {
      email_address: users(:one).email_address,
      password: "password"
    }

    assert_difference("Session.count", -1) do
      delete session_url
    end

    assert_empty flash # TODO: post signout message
    assert_redirected_to new_session_url
  end

  test "#destroy when not logged in" do
    assert_difference("Session.count", 0) do
      delete session_url
    end

    assert_empty flash
    assert_redirected_to new_session_url
  end
end
