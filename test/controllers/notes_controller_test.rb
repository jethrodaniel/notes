require "test_helper"

class NotesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @note = notes(:one)
  end

  test "get index" do
    assert_requires_login { get notes_url }

    login_as users(:one)
    get notes_url

    assert_response :success
  end

  test "new creates a new blank note" do
    assert_requires_login { get new_note_url }

    login_as users(:one)
    get new_note_url

    assert_redirected_to edit_note_path(Note.last)
  end

  test "create note" do
    assert_requires_login { post notes_url }

    login_as users(:one)
    post notes_url

    assert_difference("Note.count") do
      post notes_url, params: {
        note: {content: @note.content, user_id: @note.user_id}
      }
    end

    assert_redirected_to notes_url
  end

  test "show note" do
    assert_requires_login { get note_url(@note) }

    login_as users(:one)
    get note_url(@note)

    assert_response :success
  end

  test "get edit" do
    assert_requires_login { get edit_note_url(@note) }

    login_as users(:one)
    get edit_note_url(@note)

    assert_response :success
  end

  test "update note" do
    assert_requires_login { patch note_url(@note) }

    login_as users(:one)
    patch note_url(@note), params: {
      note: {content: @note.content, user_id: @note.user_id}
    }

    assert_redirected_to notes_url
  end

  test "destroy note" do
    assert_requires_login { delete note_url(@note) }

    login_as users(:one)

    assert_difference("Note.count", -1) do
      delete note_url(@note)
    end

    assert_redirected_to notes_url
  end
end
