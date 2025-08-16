require "test_helper"

require "capybara/cuprite"

Capybara.register_driver :cuprite_debug do |app|
  Capybara::Cuprite::Driver.new(app, inspector: ENV["INSPECTOR"])
end

# https://stackoverflow.com/questions/37769915/disabling-javascript-when-using-capybara-selenium
class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  case ENV["BROWSER"]
  in "chrome" | "chromium"
    driven_by ENV["GUI"] ? :cuprite_debug : :cuprite, screen_size: [1400, 1400]
  in "rack-test"
    driven_by :rack_test
  end

  def login_as user
    visit new_session_url
    fill_in "Email address", with: user.email_address
    fill_in "Password", with: "password"
    click_on "Sign in"

    refute_current_path new_session_url
  end

  def javascript_disabled? = ENV["BROWSER"] == "rack-test"

  def javascript_enabled? = !javascript_disabled?
end

module System
end
