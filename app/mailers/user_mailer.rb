class UserMailer < ApplicationMailer

  def account_activation(user)
    @user = user
    # user.emailにタイトルが"Account activation"のメールを送信
    mail to: user.email, subject: "Account activation"
  end

  def password_reset
    @greeting = "Hi"

    mail to: "to@example.org"
  end
end
