require "application_system_test_case"

class NotesTest < ApplicationSystemTestCase
  setup do
    @note = notes(:one)

    login_as @note.user
  end

  test "view notes" do
    visit notes_url

    assert_text notes(:one).content
    assert_text notes(:two).content
  end

  test "search notes" do # rubocop:disable Minitest/MultipleAssertions
    visit notes_url

    assert_field :q, placeholder: "Search your notes"
    assert_text notes(:one).content
    assert_text notes(:two).content

    Note.rebuild_full_text_search

    query = notes(:one).content
    fill_in "Notes search", with: query
    click_button "Search"

    assert_text "Showing 1 result for #{query}. Clear", normalize_ws: true
    assert_link "Clear", href: notes_path
    assert_current_path notes_url(q: query)
    assert_field :q, with: query
    assert_text notes(:one).content
    refute_text notes(:two).content

    query = notes(:two).content
    fill_in "Notes search", with: notes(:two).content
    click_button "Search"

    assert_text "Showing 1 result for #{query}. Clear", normalize_ws: true
    assert_link "Clear", href: notes_path
    assert_current_path notes_url(q: query)
    assert_field :q, with: query
    refute_text notes(:one).content
    assert_text notes(:two).content

    query = notes(:one).content[0]
    fill_in "Notes search", with: notes(:one).content[0]
    click_button "Search"

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

    Note.rebuild_full_text_search

    query = "Robert');DROP TABLE students; --" # https://xkcd.com/327/
    fill_in "Notes search", with: query
    click_button "Search"

    assert_text "Showing 0 results for #{query}. Clear", normalize_ws: true
    assert_link "Clear", href: notes_path
    assert_current_path notes_url(q: query)
    assert_field :q, with: query
  end

  test "search ignores non-ASCII" do
    note = Note.create! user: User.last, content: "José"

    visit notes_url

    assert_field :q, placeholder: "Search your notes"

    Note.rebuild_full_text_search

    query = "jose"
    fill_in "Notes search", with: query
    click_button "Search"

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

    Note.rebuild_full_text_search

    query = "jose"
    fill_in "Notes search", with: query
    click_button "Search"

    assert_text "Showing 0 results for #{query}. Clear", normalize_ws: true
    assert_link "Clear", href: notes_path
    assert_current_path notes_url(q: query)
    assert_field :q, with: query
    refute_text note.content
  end

  test "create a note" do
    visit notes_url

    if javascript_disabled?
      # rack-test doesn't consider screen - we see mobile and non-mobile buttons
      click_on "Add a note", match: :first
    else
      click_on "Add a note"
    end

    assert_current_path edit_note_path(Note.last)

    fill_in "Content", with: "hello!"

    assert_text "Edited just now" unless javascript_disabled?
  end

  test "view a note" do
    visit edit_note_url(@note)

    assert_field "Content", text: @note.content
    assert_text "Edited #{@note.updated_at}"
    assert_button "Update Note" if javascript_disabled?
  end

  test "update page has a back button" do
    visit edit_note_url(@note)

    assert_link "Back", href: notes_path

    click_on "Back"

    assert_current_path notes_path
  end

  test "update a note" do
    visit edit_note_url(@note)

    assert_field "Content", text: @note.content
    assert_text "Edited #{@note.updated_at}"

    fill_in "Content", with: "note is now updated"

    if javascript_enabled?
      assert_text "Edited just now"
    else
      click_on "Update Note"

      assert_current_path notes_path
      assert_text "note is now updated"
    end
  end

  test "delete a note" do
    visit edit_note_url(@note)

    if javascript_enabled?
      accept_confirm "Destroy this note?" do
        click_button "Destroy this note"
      end
    else
      click_button "Destroy this note"
    end

    assert_current_path notes_path
  end
end
