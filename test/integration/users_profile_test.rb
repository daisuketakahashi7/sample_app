require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  # Applicationヘルパーを読み込みfull_titleヘルパーが利用できる
  include ApplicationHelper

  def setup
    @user = users(:michael)
  end

  test "profile display" do
    # user_path(@user)にgetのリクエスト
    get user_path(@user)
    # users/show描写
    assert_template 'users/show'
    # 特定のHTMLタグが存在する→　title, full_title(@user.name)→@user.name | Ruby on Rails Tutorial Sample App
    assert_select 'title', full_title(@user.name)
    # 特定のHTMLタグが存在する→ h1, text: @user.name
    assert_select 'h1', text: @user.name
    # 特定のHTMLタグが存在する→ h1のタグに含まれるimg.gravatar
    assert_select 'h1>img.gravatar'
    # 描画されたページに　@userのマイクロポストのcountを文字列にしたものが含まれる
    assert_match @user.microposts.count.to_s, response.body
    # 特定のHTMLタグが存在する→ class = "pagination"を持つdiv
    assert_select 'div.pagination', count: 1   # count: 1を追加（演習13.2.3）
    # @user.micropostsのページネーションの1ページ目の配列を1個ずつ取り出してmicropostに代入
    @user.microposts.paginate(page: 1).each do |micropost|
      # このページにmicropost.contentが含まれる
      assert_match micropost.content, response.body
    end
  end
end