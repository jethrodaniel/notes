require "test_helper"

class PwaControllerTest < ActionDispatch::IntegrationTest
  test "manifest" do
    get pwa_manifest_url, as: :json

    manifest = {
      name: "Notes",
      icons: [
        {
          src: "http://www.example.com/assets/icon-512-2b945ad3.png",
          type: "image/png",
          sizes: "512x512"
        },
        {
          src: "http://www.example.com/assets/icon-512-2b945ad3.png",
          type: "image/png",
          sizes: "512x512",
          purpose: "maskable"
        },
        {
          src: "http://www.example.com/assets/icon-192-7f33fa35.png",
          type: "image/png",
          sizes: "192x192"
        },
        {
          src: "http://www.example.com/assets/icon-192-7f33fa35.png",
          type: "image/png",
          sizes: "192x192",
          purpose: "maskable"
        }
      ],
      start_url: "/",
      display: "standalone",
      scope: "/",
      description: "Notes is a note-taking application",
      theme_color: "white",
      background_color: "white"
    }

    assert_response :success
    assert_equal manifest, JSON.parse(response.body, symbolize_names: true)
  end

  test "service-worker" do
    get pwa_service_worker_url(format: :js)

    assert_response :success
  end
end
