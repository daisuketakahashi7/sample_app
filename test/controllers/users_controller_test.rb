require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  # @user変数を定義
  def setup
    @user = users(:michael)
    @other_user = users(:archer)
  end
  
  test "should get new" do
    get signup_path
    assert_response :success
  end
  
  # indexアクションのリダイレクトをテストする
  test "should redirect index when not logged in" do
    get users_path
    assert_redirected_to login_url
  end
  
  # flashが表示されていない、login_urlにリダイレクトされる
  test "should redirect edit when not logged in" do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_url
  end
  
  # user_path(@user)にpatchのリクエスト、flashが表示されていない、login_urlにリダイレクトされる
  test "should redirect update when not logged in" do
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    assert_not flash.empty?
    assert_redirected_to login_url
  end
  
  # @other_userとしてログイン、フラッシュがemptyで、root_urlにリダイレクト
  test "should redirect edit when logged in as wrong user" do
    log_in_as(@other_user)
    get edit_user_path(@user)
    assert flash.empty?
    assert_redirected_to root_url
  end
  
  # @other_userとしてログイン、@userのupdateアクションにPATCHのリクエスト　
  test "should redirect update when logged in as wrong user" do
    log_in_as(@other_user)
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    assert flash.empty?
    assert_redirected_to root_url
  end
  
  # admin属性の変更が禁止されていることをテストする
  test "should not allow the admin attribute to be edited via the web" do
    log_in_as(@other_user)
    assert_not @other_user.admin?
    patch user_path(@other_user), params: {
                                    user: { password:              "password",
                                            password_confirmation: "password",
                                            admin: true } }
    assert_not @other_user.reload.admin?
  end
  
  test "should redirect destroy when not logged in" do
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when logged in as a non-admin" do
    log_in_as(@other_user)
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to root_url
  end
  
  # フォロー/フォロワーページの認可をテスト
  test "should redirect following when not logged in" do
    get following_user_path(@user)
    assert_redirected_to login_url
  end
  
  # フォロー/フォロワーページの認可をテスト
  test "should redirect followers when not logged in" do
    get followers_user_path(@user)
    assert_redirected_to login_url
  end
end

