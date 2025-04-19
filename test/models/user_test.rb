require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "has_many sessions" do
    user = users(:one)
    Session.create!(user:, ip_address: "a", user_agent: "b")
    Session.create!(user:, ip_address: "a", user_agent: "b")

    assert_equal 2, user.sessions.count
    assert_difference("Session.count", -2) do
      user.destroy!
    end
  end

  test "has_many notes" do
    user = users(:one)

    assert_equal 2, user.notes.count
    assert_difference("Note.count", -2) do
      user.destroy!
    end
  end
end
