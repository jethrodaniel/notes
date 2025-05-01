require "application_system_test_case"

class NotesTest < ApplicationSystemTestCase
  setup do
    @note = notes(:one)

    login_as @note.user
  end

  test "view notes index" do
    visit notes_url

    assert_title "Notes"
    assert_text notes(:one).content
    assert_text notes(:two).content
  end

  test "long notes are truncated on the index page" do
    notes(:one).update! content: "a" * 271 + "hello there general"

    visit notes_url

    assert_text "a" * 271 + "hello ..."
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

    assert_title "Editing note"
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
