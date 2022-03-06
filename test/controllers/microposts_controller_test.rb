require 'test_helper'

class MicropostsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @micropost = microposts(:orange)
  end

  test "should redirect create when not logged in" do
    # Micropostの数が違わない
    assert_no_difference 'Micropost.count' do
      # microposts_pathに　paramsハッシュのデータを持たせてpostのリクエスト
      post microposts_path, params: { micropost: { content: "Lorem ipsum" } }
    end
    # login_urlにれダイレクトしているか
    assert_redirected_to login_url
  end

  test "should redirect destroy when not logged in" do
    # Micropostの数が違わない
    assert_no_difference 'Micropost.count' do
      # micropost_path(@micropost)にdeleteのリクエスト
      delete micropost_path(@micropost)
    end
    # login_urlにれダイレクトしているか
    assert_redirected_to login_url
  end
  
  test "should redirect destroy for wrong micropost" do
    # michaelとしてログイン
    log_in_as(users(:michael))
    # micropostはantsのmicroposts
    micropost = microposts(:ants)
    # ブロック内のmicropostの数に違いがない
    assert_no_difference 'Micropost.count' do
      # micropost_path(micropost)にdeleteのリクエスト
      delete micropost_path(micropost)
    end
    # root_urlにリダイレクト
    assert_redirected_to root_url
  end
end