require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest

  def setup
    # deliveries変数に配列として格納されたメールをクリア
    ActionMailer::Base.deliveries.clear
    @user = users(:michael)
  end

  test "password resets" do
    # new_password_reset_path(password_resets#new)へgetのリクエスト
    get new_password_reset_path
    # password_resets/newを描画
    assert_template 'password_resets/new'
    # input[name=?]にpassword_reset[email]が存在する
    assert_select 'input[name=?]', 'password_reset[email]'
    # メールアドレスが無効
    # password_resets_path（password_resets#create）にpostのリクエスト　無効なemailの値
    post password_resets_path, params: { password_reset: { email: "" } }
    # falseである→　flashがemptyである
    assert_not flash.empty?
    # password_resets/newを描画
    assert_template 'password_resets/new'
    # メールアドレスが有効
    # password_resets_path（password_resets#create）にpostのリクエスト　有効なemailの値
    post password_resets_path,
         params: { password_reset: { email: @user.email } }
    # 引数（変更したパスワード）の値が同じものではない→　@user.reset_digestと@user.reload.reset_digest     
    assert_not_equal @user.reset_digest, @user.reload.reset_digest
    # 引数（変更したパスワード）の値が等しい　１とActionMailer::Base.deliveriesに格納された配列の数
    assert_equal 1, ActionMailer::Base.deliveries.size
    # falseである→　flashがemptyである
    assert_not flash.empty?
    # root_urlにリダイレクト
    assert_redirected_to root_url
    # パスワード再設定フォームのテスト
    # userに@userを代入（通常統合テストからはアクセスできないattr_accessorで定義した属性の値にもアクセスできるようになる）
    user = assigns(:user)
    # メールアドレスが無効
    # edit_password_reset（password_resets#edit）にgetのリクエスト（有効なuser.reset_tokenと無効なemailを） 
    get edit_password_reset_path(user.reset_token, email: "")
    # root_urlにリダイレクト
    assert_redirected_to root_url
    # 無効なユーザー
    # userの以下のキー（:activated）の値をtoggle!メソッドで反転（無効なユーザーに）
    user.toggle!(:activated)
    # edit_password_reset（password_resets#edit）にgetのリクエスト　（リセットトークンと有効なemailを）
    get edit_password_reset_path(user.reset_token, email: user.email)
    # root_urlにリダイレクト
    assert_redirected_to root_url
    # userの以下のキー（:activated）の値をtoggle!メソッドで反転（無効なユーザーに）
    user.toggle!(:activated)
    # メールアドレスが有効で、トークンが無効
    # edit_password_reset（password_resets#edit）にgetのリクエスト　（無効なトークンと有効なemailを）
    get edit_password_reset_path('wrong token', email: user.email)
    # root_urlにリダイレクト
    assert_redirected_to root_url
    # メールアドレスもトークンも有効
    # edit_password_reset（password_resets#edit）にgetのリクエスト（有効なトークンと有効なemailを）
    get edit_password_reset_path(user.reset_token, email: user.email)
    # password_resets/editを描写
    assert_template 'password_resets/edit'
    # input[name=email][type=hidden][value=?]にuser.emailが存在するのか
    assert_select "input[name=email][type=hidden][value=?]", user.email
    # 無効なパスワードとパスワード確認
    # 引数にuser.reset_tokenを持ったpassword_reset_pathにpatchのリクエスト
    # email: user.emailと無効なパスワードとパスワード確認（それぞれの値が合わない）
    patch password_reset_path(user.reset_token),
          params: { email: user.email,
                    user: { password:              "foobaz",
                            password_confirmation: "barquux" } }
    # div#error_explanationが存在する                            
    assert_select 'div#error_explanation'
    # パスワードが空
    # 引数にuser.reset_tokenを持ったpassword_reset_pathにpatchのリクエスト
    # email: user.emailと空のパスワード
    patch password_reset_path(user.reset_token),
          params: { email: user.email,
                    user: { password:              "",
                            password_confirmation: "" } }
    # div#error_explanationが存在する                        
    assert_select 'div#error_explanation'
    # 有効なパスワードとパスワード確認
    # 引数にuser.reset_tokenを持ったpassword_reset_pathにpatchのリクエスト
    # email: user.emailと有効なパスワードとパスワード確認
    patch password_reset_path(user.reset_token),
          params: { email: user.email,
                    user: { password:              "foobaz",
                            password_confirmation: "foobaz" } }
    # 再読み込みしたらダイジェストがnilかどうか（演習12.3）                            
    assert_nil user.reload.reset_digest
    # trueであるテストユーザーがログイン（test_helper.rbからメソッドの呼び出し）                            
    assert is_logged_in?
    # falseである　flashがemptyである
    assert_not flash.empty?
    # userの詳細ページにリダイレクトされる
    assert_redirected_to user
  end
  
  # パスワード再設定の期限切れのテスト(演習12.3)
  test "expired token" do
    get new_password_reset_path
    post password_resets_path,
         params: { password_reset: { email: @user.email } }

    @user = assigns(:user)
    @user.update_attribute(:reset_sent_at, 3.hours.ago)
    patch password_reset_path(@user.reset_token),
          params: { email: @user.email,
                    user: { password:              "foobar",
                            password_confirmation: "foobar" } }
    assert_response :redirect
    follow_redirect!
    assert_match 'expired', response.body
  end
end