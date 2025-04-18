require "test_helper"

class NoteTest < ActiveSupport::TestCase
  test "belongs_to user" do
    assert_equal users(:one), notes(:one).user
  end

  test "implicit_order_column" do
    assert_equal :created_at, Note.implicit_order_column
  end
end
