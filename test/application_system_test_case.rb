require "test_helper"

module SystemTestHelpers
  def login_as user
    visit new_session_url
    fill_in "Email address", with: user.email_address
    fill_in "Password", with: "password"
    click_on "Sign in"

    refute_current_path new_session_url
  end
end

require "capybara/cuprite"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :cuprite, screen_size: [1400, 1400]

  include SystemTestHelpers
end
