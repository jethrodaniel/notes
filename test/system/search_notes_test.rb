require "application_system_test_case"

class SearchNotesTest < ApplicationSystemTestCase
  setup do
    Note.rebuild_full_text_search

    login_as notes(:one).user
  end

  test "search notes" do # rubocop:disable Minitest/MultipleAssertions
    visit notes_url

    assert_field :q, placeholder: "Search your notes"
    assert_text notes(:one).content
    assert_text notes(:two).content

    query = notes(:one).content
    fill_in "Notes search", with: query
    click_button "Search" unless javascript_enabled?

    assert_text "Showing 1 result for #{query}. Clear", normalize_ws: true
    assert_link "Clear", href: notes_path
    assert_current_path notes_url(q: query)
    assert_field :q, with: query
    assert_text notes(:one).content
    refute_text notes(:two).content

    query = notes(:two).content
    fill_in "Notes search", with: notes(:two).content
    click_button "Search" unless javascript_enabled?

    assert_text "Showing 1 result for #{query}. Clear", normalize_ws: true
    assert_link "Clear", href: notes_path
    assert_current_path notes_url(q: query)
    assert_field :q, with: query
    refute_text notes(:one).content
    assert_text notes(:two).content

    query = "note"
    fill_in "Notes search", with: query
    click_button "Search" unless javascript_enabled?

    assert_text "Showing 2 results for #{query}. Clear", normalize_ws: true
    assert_link "Clear", href: notes_path
    assert_current_path notes_url(q: query)
    assert_field :q, with: query
    assert_text notes(:one).content
    assert_text notes(:two).content
  end

  test "search sanitizes input" do
    visit notes_url

    assert_field :q, placeholder: "Search your notes"

    query = "Robert');DROP TABLE students; --" # https://xkcd.com/327/
    fill_in "Notes search", with: query
    click_button "Search" unless javascript_enabled?

    assert_text "Showing 0 results for #{query}. Clear", normalize_ws: true
    assert_link "Clear", href: notes_path
    assert_current_path notes_url(q: query)
    assert_field :q, with: query
  end

  test "search ignores non-ASCII" do
    note = Note.create! user: User.last, content: "José"

    visit notes_url

    assert_field :q, placeholder: "Search your notes"

    query = "jose"
    fill_in "Notes search", with: query
    click_button "Search" unless javascript_enabled?

    assert_text "Showing 1 result for #{query}. Clear", normalize_ws: true
    assert_link "Clear", href: notes_path
    assert_current_path notes_url(q: query)
    assert_field :q, with: query
    assert_text note.content
  end

  test "search is limited to the user's own notes" do
    note = Note.create! user: users(:two), content: "José"

    visit notes_url

    assert_field :q, placeholder: "Search your notes"

    query = "jose"
    fill_in "Notes search", with: query
    click_button "Search" unless javascript_enabled?

    assert_text "Showing 0 results for #{query}. Clear", normalize_ws: true
    assert_link "Clear", href: notes_path
    assert_current_path notes_url(q: query)
    assert_field :q, with: query
    refute_text note.content
  end

  test "search clear link" do
    visit notes_url

    query = notes(:one).content
    fill_in "Notes search", with: query
    click_button "Search" if javascript_disabled?

    assert_text "Showing 1 result for #{query}. Clear", normalize_ws: true
    assert_link "Clear", href: notes_path
    assert_current_path notes_url(q: query)
    assert_field :q, with: query

    click_on "Clear"

    assert_current_path notes_url
    assert_field :q, placeholder: "Search your notes"

    refute_text "Showing", normalize_ws: true
    refute_link "Clear"
  end

  test "clear out search input manually" do
    visit notes_url

    query = notes(:one).content
    fill_in "Notes search", with: query
    click_button "Search" if javascript_disabled?

    assert_text "Showing 1 result for #{query}. Clear", normalize_ws: true
    assert_link "Clear", href: notes_path
    assert_current_path notes_url(q: query)
    assert_field :q, with: query

    # NOTE: if we just blank out the input, then the search doesn't submit.
    # Not sure why, but filling in anything else avoids the issue.
    #
    # TODO: understand
    #
    fill_in "Notes search", with: "1"
    fill_in "Notes search", with: ""
    click_button "Search" if javascript_disabled?

    assert_current_path notes_url(q: "")
    assert_field :q, with: ""
    refute_text "Showing", normalize_ws: true
    refute_link "Clear"
  end
end
