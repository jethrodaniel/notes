require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "has_many sessions" do
    user = User.create!(email_address: "a@b.c", password: "123")
    Session.create!(user:, ip_address: "a", user_agent: "b")
    Session.create!(user:, ip_address: "a", user_agent: "b")

    assert_equal 2, user.sessions.count
  end
end
