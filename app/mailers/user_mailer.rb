class UserMailer < ApplicationMailer

  def account_activation(user)
    @user = user
    # user.emailにタイトルが"Account activation"のメールを送信
    mail to: user.email, subject: "Account activation"
  end

  # パスワード再設定のリンクをメール送信する
  def password_reset(user)
    # インスタンス変数を定義
    @user = user
    # user.emailにタイトルが"t('.password_reset')"のメールを送信
    mail to: user.email, subject: "Password reset"
  end
end
