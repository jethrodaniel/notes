require "test_helper"

class NoteTest < ActiveSupport::TestCase
  test "belongs_to user" do
    assert_equal users(:one), notes(:one).user
  end

  test "implicit_order_column" do
    assert_equal :created_at, Note.implicit_order_column
  end

  test "full_text_search" do
    Note.delete_all

    user = users(:one)
    one_two = Note.create!(content: "one two", user:)
    two_three = Note.create!(content: "two three", user: users(:two))
    four = Note.create!(content: "four zero", user:)
    four_five = Note.create!(title: "five zero", content: "four", user:)

    assert_kind_of ActiveRecord::Relation, Note.full_text_search("a")

    {
      # https://sqlite.org/fts5.html#fts5_initial_token_queries
      "one" => [one_two],
      "two" => [one_two, two_three],
      "three" => [two_three],
      "four" => [four, four_five],

      # https://sqlite.org/fts5.html#fts5_phrases
      "t*" => [two_three, one_two],
      "th*" => [two_three]
    }.each do |query, notes|
      assert_equal(
        notes.map(&:content),
        Note.full_text_search(query).map(&:content),
        "search for content '#{query}'"
      )
    end

    assert_equal(
      [four_five].map(&:title),
      Note.full_text_search("five").map(&:title),
      "search for title 'five'"
    )

    assert_equal(
      [four, four_five],
      Note.full_text_search("zero"),
      "search for title or content 'zero'"
    )
  end

  test "full_text_search sanitizes input" do
    [
      # https://xkcd.com/327/
      "Robert');DROP TABLE students; --",

      # only non-words
      "'",
      "'--",
      " "
    ].each do |query|
      assert_empty Note.full_text_search(query).to_a, "search for '#{query}'"
    end
  end

  test "adding a note adds to the full text search" do
    assert_empty Note.full_text_search("foo")

    Note.create!(content: "foo", user: users(:one))

    assert_equal(
      ["foo"],
      Note.full_text_search("foo").map(&:content),
      "search for 'foo'"
    )
  end

  test "updating a note updates the full text search" do
    assert_empty Note.full_text_search("foo")

    note = Note.create!(content: "foo", user: users(:one))
    note.update! content: "bar"

    assert_equal(
      ["bar"],
      Note.full_text_search("bar").map(&:content),
      "search for 'bar'"
    )
    assert_empty Note.full_text_search("foo")
  end

  test "deleting a note deletes from the full text search" do
    assert_empty Note.full_text_search("foo")

    note = Note.create!(content: "foo", user: users(:one))

    assert_equal(
      ["foo"],
      Note.full_text_search("foo").map(&:content),
      "search for 'foo'"
    )

    note.destroy!

    assert_empty Note.full_text_search("foo")
  end

  test "rebuild full text search" do
    assert_empty Note.full_text_search("one")

    Note.rebuild_full_text_search

    assert_not_empty Note.full_text_search("one")
  end
end
