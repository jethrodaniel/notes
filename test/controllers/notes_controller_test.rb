require "test_helper"

class NotesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @note = notes(:one)
  end

  test "get index requires login" do
    assert_requires_login { get notes_url }
  end

  test "get index" do
    login_as users(:one)
    get notes_url

    assert_response :success

    assert_dom "title", text: "Notes"
    assert_dom "input[id='q']", placeholder: "Search your notes"
  end

  test "get index in spanish" do
    login_as users(:es)
    get notes_url

    assert_response :success

    assert_dom "title", text: "Notas"
    assert_dom "input[id='q'][placeholder=?]", "Busca en tus notas"
  end

  test "create note requires login" do
    assert_requires_login { post notes_url }
  end

  test "create note" do
    login_as users(:one)

    assert_difference("Note.count", 1) do
      post notes_url, params: {
        note: {content: "foo", user_id: users(:one).id}
      }
    end
    assert_redirected_to edit_note_path(Note.last)
    assert_equal "Note was successfully created.", flash[:notice]
  end

  test "create note in spanish" do
    login_as users(:es)

    assert_difference("Note.count", 1) do
      post notes_url, params: {
        note: {content: "foo", user_id: users(:es).id}
      }
    end
    assert_redirected_to edit_note_path(Note.last)
    assert_equal "La nota se ha creado con éxito.", flash[:notice]
  end

  test "get edit requires login" do
    assert_requires_login { get edit_note_url(@note) }
  end

  test "get edit" do
    login_as users(:one)
    get edit_note_url(@note)

    assert_response :success

    assert_dom "title", text: "Editing note"
    assert_dom "small[id='#{dom_id(@note)}_edited_at']",
      "Edited #{@note.updated_at}"
  end

  test "get edit in spanish" do
    login_as users(:one).tap { it.update! language: :es }
    get edit_note_url(@note)

    assert_response :success

    assert_dom "title", text: "Editar nota"
    assert_dom "small[id='#{dom_id(@note)}_edited_at']",
      "Editado #{@note.updated_at}"
  end

  test "update note requires login" do
    assert_requires_login { patch note_url(@note) }
  end

  test "update note" do
    login_as users(:one)
    patch note_url(@note), params: {
      note: {content: "foo", user_id: users(:one).id}
    }

    assert_redirected_to notes_url
    assert_equal "Note was successfully updated.", flash[:notice]
  end

  test "update note in spanish" do
    login_as users(:es)
    patch note_url(@note), params: {
      note: {content: "foo", user_id: users(:es).id}
    }

    assert_redirected_to notes_url
    assert_equal "La nota se actualizó con éxito.", flash[:notice]
  end

  test "destroy note requires login" do
    assert_requires_login { delete note_url(@note) }
  end

  test "destroy note" do
    login_as users(:one)

    assert_difference("Note.count", -1) do
      delete note_url(@note)
    end

    assert_redirected_to notes_url
    assert_equal "Note was successfully destroyed.", flash[:notice]
  end

  test "destroy note in spanish" do
    login_as users(:es)

    assert_difference("Note.count", -1) do
      delete note_url(@note)
    end

    assert_redirected_to notes_url
    assert_equal "La nota se ha destruido con éxito.", flash[:notice]
  end
end
