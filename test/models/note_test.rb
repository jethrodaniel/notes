require "test_helper"

class NoteTest < ActiveSupport::TestCase
  test "belongs_to user" do
    assert_equal users(:one), notes(:one).user
  end

  test "implicit_order_column" do
    assert_equal :created_at, Note.implicit_order_column
  end

  test "full_text_search" do
    Note.destroy_all

    one_two = Note.create!(content: "one two", user: users(:one))
    two_three = Note.create!(content: "two three", user: users(:two))
    four = Note.create!(content: "four", user: users(:one))

    assert_kind_of ActiveRecord::Relation, Note.full_text_search("a")

    {
      # https://sqlite.org/fts5.html#fts5_initial_token_queries
      "one" => [one_two],
      "two" => [one_two, two_three],
      "three" => [two_three],
      "four" => [four],

      # https://sqlite.org/fts5.html#fts5_phrases
      "t*" => [two_three, one_two],
      "th*" => [two_three]
    }.each do |query, notes|
      assert_equal(
        notes.map(&:content),
        Note.full_text_search(query).map(&:content),
        "search for '#{query}'"
      )
    end
  end

  test "full_text_search sanitizes input" do
    Note.delete_all

    # assert_equal "", Note.full_text_search("Robert');DROP TABLE students; --").to_sql

     # https://xkcd.com/327/
    assert_equal [], Note.full_text_search("Robert');DROP TABLE students; --").to_a
  end
end
