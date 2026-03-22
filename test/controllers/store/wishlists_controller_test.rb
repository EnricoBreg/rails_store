require "test_helper"

class Store::WishlistsControllerTest < ActionDispatch::IntegrationTest
  test "should get extends:Store::BaseController" do
    get store_wishlists_extends:Store::BaseController_url
    assert_response :success
  end
end
