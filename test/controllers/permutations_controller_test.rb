require "test_helper"

class PermutationsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get permutations_show_url
    assert_response :success
  end
end
