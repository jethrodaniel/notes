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

    assert_field placeholder: "Search your notes"

    fill_in "Search your notes", with: "TODO"

    skip :TODO
  end

  test "create a note" do
    visit notes_url
    click_on "Add a note"

    assert_current_path edit_note_path(Note.last)

    fill_in "Content", with: "hello!"

    assert_text "Note updated!"
  end

  test "view a note" do
    visit edit_note_url(@note)

    assert_field "Content", text: @note.content
    assert_text "Edited #{@note.updated_at}"
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

    fill_in "Content", with: @note.content

    assert_text "Note updated!"
    refute_text "Edited"
  end

  test "delete a note, but dismiss alert" do
    visit edit_note_url(@note)

    dismiss_confirm "Destroy this note?" do
      click_button "Destroy this note"
    end

    assert_current_path edit_note_url(@note)
  end

  test "delete a note" do
    visit edit_note_url(@note)

    accept_confirm "Destroy this note?" do
      click_button "Destroy this note"
    end

    assert_current_path notes_path
  end
end
