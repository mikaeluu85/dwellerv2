require "test_helper"

class BrandsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get brands_show_url
    assert_response :success
  end
end
