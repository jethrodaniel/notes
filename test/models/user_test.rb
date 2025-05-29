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

  test "validates language" do
    assert_equal "en", users(:one).language
    assert_predicate users(:one), :valid?

    assert_equal "es", users(:es).language
    assert_predicate users(:es), :valid?

    users(:one).language = "foo"

    assert_not_predicate users(:one), :valid?
    assert_equal ["is not included in the list"], users(:one).errors[:language]
  end
end
