require "test_helper"

class AdvertisersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get advertisers_index_url
    assert_response :success
  end
end
