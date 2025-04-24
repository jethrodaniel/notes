require "test_helper"

class SettingsControllerTest < ActionDispatch::IntegrationTest
  test "get index" do
    assert_requires_login { get settings_path }

    login_as users(:one)
    get settings_path

    assert_response :success
  end
end
