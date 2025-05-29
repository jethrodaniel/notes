require "test_helper"

class SettingsControllerTest < ActionDispatch::IntegrationTest
  test "get index requires login" do
    assert_requires_login { get settings_path }
  end

  test "get index" do
    login_as users(:one)
    get settings_path

    assert_response :success

    assert_dom "title", text: "Settings"
    assert_dom "label[for='user_language']", text: "Language"
    assert_dom "select[id='user_language']" do
      assert_dom "option[selected='selected'][value='en']", text: "English"
      assert_dom "option[value='es']", text: "Spanish"
    end
    assert_dom "input[type='submit'][value=?]", "Save"
  end

  test "get index in spanish" do
    login_as users(:es)
    get settings_path

    assert_response :success

    assert_dom "title", text: "Configuración"
    assert_dom "label[for='user_language']", text: "Idioma"
    assert_dom "select[id='user_language']" do
      assert_dom "option[value='en']", text: "Inglés"
      assert_dom "option[selected='selected'][value='es']", text: "Español"
    end
    assert_dom "input[type='submit'][value=?]", "Salvar"
  end

  test "update language from english to spanish" do
    assert_requires_login { get settings_path }
    login_as users(:one)

    assert_changes -> { users(:one).reload.language }, from: "en", to: "es" do
      patch settings_path, params: {
        user: {language: "es"}
      }
    end
    assert_redirected_to settings_url
    assert_equal(
      "La configuración se actualizó correctamente.",
      flash[:notice]
    )
  end

  test "update language from spanish to english" do
    assert_requires_login { get settings_path }
    login_as users(:es)

    assert_changes -> { users(:es).reload.language }, from: "es", to: "en" do
      patch settings_path, params: {
        user: {language: "en"}
      }
    end
    assert_redirected_to settings_url
    assert_equal(
      "Settings were successfully updated.",
      flash[:notice]
    )
  end

  test "update language to an invalid value" do
    login_as users(:one)

    patch settings_path, params: {
      user: {language: "foobar"}
    }

    assert_response :unprocessable_entity
  end
end
