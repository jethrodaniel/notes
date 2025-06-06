require "test_helper"

class NotesControllerTest < ActionDispatch::IntegrationTest
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
        note: {content: "foo"}
      }
    end
    assert_redirected_to edit_note_path(Note.last)
    assert_empty flash
    assert_equal Note.last.user, users(:one)
  end

  test "get edit requires login" do
    assert_requires_login { get edit_note_url(notes(:one)) }
  end

  test "get edit" do
    login_as users(:one)
    get edit_note_url(notes(:one))

    assert_response :success

    assert_dom "title", text: "Editing note"
    assert_dom "small[id='#{dom_id(notes(:one))}_edited_at']",
      "Edited #{notes(:one).updated_at}"
  end

  test "get edit in spanish" do
    login_as users(:es)
    get edit_note_url(notes(:es_one))

    assert_response :success

    assert_dom "title", text: "Editar nota"
    assert_dom "small[id='#{dom_id(notes(:es_one))}_edited_at']",
      "Editado #{notes(:es_one).updated_at}"
  end

  test "get edit only shows the user's notes" do
    login_as users(:one)

    get edit_note_url(notes(:es_one))

    assert_response :not_found
  end

  test "update note requires login" do
    assert_requires_login { patch note_url(notes(:one)) }
  end

  test "update note" do
    login_as users(:one)
    patch note_url(notes(:one)), params: {
      note: {content: "foo"}
    }

    assert_redirected_to notes_url
    assert_equal "Note was successfully updated.", flash[:notice]
  end

  test "update note in spanish" do
    login_as users(:es)
    patch note_url(notes(:es_one)), params: {
      note: {content: "foo"}
    }

    assert_redirected_to notes_url
    assert_equal "La nota se actualizó con éxito.", flash[:notice]
  end

  test "update note only allows updating the user's notes" do
    login_as users(:one)

    patch note_url(notes(:es_one)), params: {
      note: {content: "foo"}
    }

    assert_response :not_found
  end

  test "destroy note requires login" do
    assert_requires_login { delete note_url(notes(:one)) }
  end

  test "destroy note" do
    login_as users(:one)
    note = notes(:one)

    assert_difference("Note.count", -1) do
      delete note_url(note)
    end

    assert_redirected_to notes_url
    assert_equal "Note was successfully destroyed.", flash[:notice]
  end

  test "destroy note in spanish" do
    login_as users(:es)
    note = notes(:es_one)

    assert_difference("Note.count", -1) do
      delete note_url(note)
    end

    assert_redirected_to notes_url
    assert_equal "La nota se ha destruido con éxito.", flash[:notice]
  end

  test "destroy note only allows deleting the user's notes" do
    login_as users(:one)

    delete note_url(notes(:es_one))

    assert_response :not_found
  end

  test "destroy note (turbo stream)" do
    login_as users(:one)
    note = notes(:one)

    delete note_url(note, format: :turbo_stream)

    assert_turbo_stream(
      target: dom_id(Note, :empty_note_discarded),
      action: "replace"
    ) do
      assert_dom "*", "Empty note discarded"
    end
  end

  test "destroy note in spanish (turbo stream)" do
    login_as users(:es)
    note = notes(:es_one)

    delete note_url(note, format: :turbo_stream)

    assert_turbo_stream(
      target: dom_id(Note, :empty_note_discarded),
      action: "replace"
    ) do
      assert_dom "*", "Nota vacía descartada"
    end
  end
end
