require "test_helper"

class NoteTest < ActiveSupport::TestCase
  test "belongs_to user" do
    user = User.create!(email_address: "a@b.c", password: "123")
    note = Note.create!(user:, content: "foo")

    assert_predicate note, :valid?
    assert_equal user, note.user
  end
end
