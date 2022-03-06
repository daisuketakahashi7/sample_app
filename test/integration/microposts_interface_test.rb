require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest

  def setup
    # @userはmichael
    @user = users(:michael)
  end

  test "micropost interface" do
    # @userでログイン
    log_in_as(@user)
    # root_pathにgetのリクエスト
    get root_path
    # divタグにpaginationタグが存在する
    assert_select 'div.pagination'
    # inputに[type=file]が存在する（演習13.4.1）
    assert_select 'input[type=file]'
    # 無効な送信
    # ブロック内で渡されたものの個数に違いがない
    assert_no_difference 'Micropost.count' do
      # microposts_pathにpostリクエスト、
      post microposts_path, params: { micropost: { content: "" } }
    end
    # assert_select 'div#error_explanation'　micropost: { content: content }は有効なデータ
    assert_select 'a[href=?]', '/?page=2'  # 正しいページネーションリンク
    # 有効な送信
    content = "This micropost really ties the room together"
    # imageにアップロードされたimage/jpegを代入
    image = fixture_file_upload('test/fixtures/kitten.jpg', 'image/jpeg')
    # ブロック内で渡されたものの個数に違いがない
    assert_difference 'Micropost.count', 1 do
      # microposts_pathにposgリクエスト、contentにtontent,imageにimageの有効なデータ（演習13.4.1）
      post microposts_path, params: { micropost:
                                      { content: content, image: image } }
    end
    # micropostインスタンスにimageがattachedされている（演習13.4.1）
    assert assigns(:micropost).image.attached?
    # root_urlにリダイレクト
    assert_redirected_to root_url
    # 指定されたリダイレクト先に移動
    follow_redirect!
    # 表示されたページのHTML本文すべての中にcontentが含まれている
    assert_match content, response.body
    # 投稿を削除する
    # 特定のHTMLタグが存在する→　text: 'delete'を持つa
    assert_select 'a', text: 'delete'
    # first_micropostに代入　@user.micropostsの1ページ目の1番目のマイクロポスト
    first_micropost = @user.microposts.paginate(page: 1).first
    # ブロックで渡されたものを呼び出す前後でMicropost.countが-1
    assert_difference 'Micropost.count', -1 do
      # micropost_path(first_micropost)にdeleteリクエスト
      delete micropost_path(first_micropost)
    end
    # 違うユーザーのプロフィールにアクセス（削除リンクがないことを確認）
    # user_path(users(:archer))にgetリクエスト
    get user_path(users(:archer))
    # 特定のHTMLタグが存在する→　text: 'delete'を持つaが0個
    assert_select 'a', text: 'delete', count: 0
  end
  
  # マイクロポストの合計投稿数をテスト(13.3の演習)
  test "micropost sidebar count" do
    log_in_as(@user)
    get root_path
    assert_match "#{@user.microposts.count} microposts", response.body
    # まだマイクロポストを投稿していないユーザー
    other_user = users(:malory)
    log_in_as(other_user)
    get root_path
    assert_match "0 microposts", response.body
    other_user.microposts.create!(content: "A micropost")
    get root_path
    assert_match "1 micropost", response.body
  end
end