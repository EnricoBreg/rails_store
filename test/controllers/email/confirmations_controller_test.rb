require "test_helper"

class Email::ConfirmationsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get email_confirmations_show_url
    assert_response :success
  end
end
