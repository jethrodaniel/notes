require "test_helper"

class PreferencesControllerTest < ActionDispatch::IntegrationTest
  class BaseTests < self
    test "get edit requires login" do
      assert_requires_login { get preferences_path }
    end

    test "get edit" do
      sign_in_as users(:one)
      get preferences_path

      assert_response :success

      assert_dom "title", text: "Preferences"

      assert_dom "label[for='preferences_language']", text: "Language"
      assert_dom "select[id='preferences_language']" do
        assert_dom "option[selected='selected'][value='en']", text: "English"
        assert_dom "option[value='es']", text: "Spanish"
      end

      assert_dom "label[for='preferences_note_index_truncate_length']",
        text: "Note truncate length"
      assert_dom(
        "input[id='preferences_note_index_truncate_length']"
      ).tap do |input|
        assert_equal "number", input.first["type"]
        assert_equal "280", input.first["value"]
        assert_equal "3", input.first["size"]
      end

      assert_dom "input[type='submit'][value=?]", "Save"
    end

    test "get edit in spanish" do
      sign_in_as users(:es)
      get preferences_path

      assert_response :success

      assert_dom "title", text: "Configuración"

      assert_dom "label[for='preferences_language']", text: "Idioma"
      assert_dom "select[id='preferences_language']" do
        assert_dom "option[value='en']", text: "Inglés"
        assert_dom "option[selected='selected'][value='es']", text: "Español"
      end

      assert_dom "label[for='preferences_note_index_truncate_length']",
        text: "Tenga en cuenta la longitud truncada"
      assert_dom(
        "input[id='preferences_note_index_truncate_length']"
      ).tap do |input|
        assert_equal "number", input.first["type"]
        assert_equal "280", input.first["value"]
        assert_equal "3", input.first["size"]
      end

      assert_dom "input[type='submit'][value=?]", "Salvar"
    end
  end

  class LanguageTests < self
    test "update language from english to spanish" do
      sign_in_as users(:one)

      assert_changes -> {
        users(:one).reload.preferences.language
      }, from: "en", to: "es" do
        patch preferences_path, params: {
          preferences: {language: "es"}
        }
      end
      assert_redirected_to preferences_url
      assert_equal(
        "La configuración se actualizó correctamente.",
        flash[:notice]
      )
    end

    test "update language from spanish to english" do
      sign_in_as users(:es)

      assert_changes -> {
        users(:es).reload.preferences.language
      }, from: "es", to: "en" do
        patch preferences_path, params: {
          preferences: {language: "en"}
        }
      end
      assert_redirected_to preferences_url
      assert_equal(
        "Preferences were successfully updated.",
        flash[:notice]
      )
    end

    test "update language to an invalid value" do
      sign_in_as users(:one)

      patch preferences_path, params: {
        preferences: {language: "foobar"}
      }

      assert_response :unprocessable_content
    end
  end

  class NoteIndexTruncateLengthTests < self
    test "update note_index_truncate_length" do
      sign_in_as users(:one)

      assert_changes -> {
        users(:one).reload.preferences.note_index_truncate_length
      }, from: 280, to: 10 do
        patch preferences_path, params: {
          preferences: {note_index_truncate_length: "10"}
        }
      end
      assert_redirected_to preferences_url
      assert_equal(
        "Preferences were successfully updated.",
        flash[:notice]
      )
    end

    test "update language to an invalid value" do
      sign_in_as users(:one)

      patch preferences_path, params: {
        preferences: {note_index_truncate_length: "foobar"}
      }

      assert_response :unprocessable_content
    end
  end
end
