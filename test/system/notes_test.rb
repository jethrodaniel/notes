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

  test "view a note" do
    visit edit_note_url(@note)

    assert_field "Content", text: @note.content
    assert_text "Edited #{@note.updated_at}"

    assert_button "Update Note"
  end

  test "update page has a back button" do
    visit edit_note_url(@note)

    assert_link "Back", href: notes_path

    click_on "Back"

    assert_field placeholder: "Search your notes"
    assert_current_path notes_path
  end

  test "update a note" do
    visit edit_note_url(@note)

    fill_in "Content", with: @note.content
    click_on "Update Note"

    assert_current_path notes_path
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
