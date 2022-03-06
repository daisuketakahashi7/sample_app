class ApplicationController < ActionController::Base
  # ApplicationコントローラにSessionヘルパーモジュールを読み込む
  include SessionsHelper
  
  private

    # ユーザーのログインを確認する
    def logged_in_user
      # logged_in?がfalseの場合
      unless logged_in?
        # SessionsHelperメソッド　store_locationの呼び出し
        store_location
        # flashsでエラーメッセージを表示
        flash[:danger] = "Please log in."
        # ogin_urlにリダイレクト
        redirect_to login_url
      end
    end
end