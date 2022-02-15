require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    # #名前付きルートの修正
    get login_path
    assert_response :success
  end

end
