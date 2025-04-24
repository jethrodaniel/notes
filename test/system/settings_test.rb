require "application_system_test_case"

class SettingsTest < ApplicationSystemTestCase
  setup do
    login_as users(:one)
  end

  test "sign out" do
    visit settings_url

    assert_title "Settings"
    assert_text "Settings"

    if javascript_enabled?
      accept_confirm "Sign out?" do
        click_button "Sign out"
      end
    else
      click_button "Sign out"
    end

    assert_current_path new_session_path
  end
end
