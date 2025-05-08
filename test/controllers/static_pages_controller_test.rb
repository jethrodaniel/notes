require "test_helper"

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  test "offline" do
    get offline_url

    assert_response :success

    assert_dom "title", text: "Offline"
    assert_dom "h1", text: "Looks like you're offline..."
    assert_dom "p", text: "Check your network connection and try again."
  end
end
