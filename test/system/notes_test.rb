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

    fill_in "Content", with: @note.content
    click_on "Create Note"

    assert_current_path notes_path
    assert_text @note.content
  end

  test "update page has a back button" do
    visit note_url(@note)

    assert_link "Back", href: notes_path

    click_on "Back"
    assert_field placeholder: "Search your notes"
    assert_current_path notes_path
  end

  test "update a note" do
    visit note_url(@note)

    click_on "Edit this note", match: :first

    fill_in "Content", with: @note.content
    click_on "Update Note"

    assert_current_path notes_path
  end

  test "delete a note" do
    visit note_url(@note)

    skip :TODO

    click_on "Destroy this note", match: :first

    assert_current_path notes_path
    assert_text "Note moved to trash. Undo?"
  end
end
