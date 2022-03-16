require 'test_helper'

class FollowingTest < ActionDispatch::IntegrationTest

  def setup
    # @userにmichael代入
    @user = users(:michael)
    # @otherにarcherを代入
    @other = users(:archer)
    # @user（michael）としてログイン
    log_in_as(@user)
  end
  
    test "following page" do
    # /users/@userのid/followingにgetのリクエスト
    get following_user_path(@user)
    # @user.following.empty?がfalseである
    assert_not @user.following.empty?
    # フォローしている数を文字列にして、ボディにも存在することが一致
    assert_match @user.following.count.to_s, response.body
    # @user.followingを順に取り出してuserに代入
    @user.following.each do |user|
      # userパスのタグが存在する（a href = "/users/userのid"）
      assert_select "a[href=?]", user_path(user)
    end
  end

  test "followers page" do
    # followers_user_path(@user)にgetリクエスト
    get followers_user_path(@user)
    # @user.followers.empty?がfalseである
    assert_not @user.followers.empty?
    # フォローしている数を文字列にして、ボディにも存在することが一致
    assert_match @user.followers.count.to_s, response.body
    @user.followers.each do |user|
      # userパスのタグが存在する（a href = "/users/userのid"）
      assert_select "a[href=?]", user_path(user)
    end
  end
  
  # 標準的なフォローに対するテスト
  test "should follow a user the standard way" do
    assert_difference '@user.following.count', 1 do
      post relationships_path, params: { followed_id: @other.id }
    end
  end
  
  # Ajaxに対するフォローのテスト
  test "should follow a user with Ajax" do
    assert_difference '@user.following.count', 1 do
      post relationships_path, xhr: true, params: { followed_id: @other.id }
    end
  end
  # 標準的なフォロー解除に対するテスト
  test "should unfollow a user the standard way" do
    @user.follow(@other)
    relationship = @user.active_relationships.find_by(followed_id: @other.id)
    assert_difference '@user.following.count', -1 do
      delete relationship_path(relationship)
    end
  end
  
  # Ajaxに対するフォロー解除のテスト
  test "should unfollow a user with Ajax" do
    @user.follow(@other)
    relationship = @user.active_relationships.find_by(followed_id: @other.id)
    assert_difference '@user.following.count', -1 do
      delete relationship_path(relationship), xhr: true
    end
  end
end