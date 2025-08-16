require "test_helper"

class PreferencesControllerTest < ActionDispatch::IntegrationTest
  test "get index requires login" do
    assert_requires_login { get preferences_path }
  end

  test "get index" do
    login_as users(:one)
    get preferences_path

    assert_response :success

    assert_dom "title", text: "Preferences"
    assert_dom "label[for='preferences_language']", text: "Language"
    assert_dom "select[id='preferences_language']" do
      assert_dom "option[selected='selected'][value='en']", text: "English"
      assert_dom "option[value='es']", text: "Spanish"
    end
    assert_dom "input[type='submit'][value=?]", "Save"
  end

  test "get index in spanish" do
    login_as users(:es)
    get preferences_path

    assert_response :success

    assert_dom "title", text: "Configuración"
    assert_dom "label[for='preferences_language']", text: "Idioma"
    assert_dom "select[id='preferences_language']" do
      assert_dom "option[value='en']", text: "Inglés"
      assert_dom "option[selected='selected'][value='es']", text: "Español"
    end
    assert_dom "input[type='submit'][value=?]", "Salvar"
  end

  test "update language from english to spanish" do
    assert_requires_login { get preferences_path }
    login_as users(:one)

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
    assert_requires_login { get preferences_path }
    login_as users(:es)

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
    login_as users(:one)

    patch preferences_path, params: {
      preferences: {language: "foobar"}
    }

    assert_response :unprocessable_entity
  end
end
