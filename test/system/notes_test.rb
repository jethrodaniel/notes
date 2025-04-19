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

  test "search notes" do
    visit notes_url

    assert_field :q, placeholder: "Search your notes"
    assert_text notes(:one).content
    assert_text notes(:two).content

    Note.rebuild_full_text_search

    fill_in "Notes search", with: notes(:one).content
    click_button "Search"

    assert_current_path notes_url(q: notes(:one).content)
    assert_field :q, with: notes(:one).content
    assert_text notes(:one).content
    refute_text notes(:two).content
  end

  test "create a note" do
    visit notes_url

    if javascript_disabled?
      # rack-test doesn't consider screen size, we see mobile and non-mobile
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
