class PasswordResetsController < ApplicationController
  # privateの下の分に対してのフィルター
  before_action :get_user,   only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]
  
  def new
  end
  
  # パスワード再設定用のcreateアクション
  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = "Email sent with password reset instructions"
      redirect_to root_url
    else
      flash.now[:danger] = "Email address not found"
      render 'new'
    end
  end

  def edit
  end
  
  def update
    if params[:user][:password].empty?                  # （3）への対応
      @user.errors.add(:password, :blank)
      render 'edit'
    elsif @user.update(user_params)                     # （4）への対応
      log_in @user
      # パスワード再設定が成功したらダイジェストをnilにする
      @user.update_attribute(:reset_digest, nil)
      flash[:success] = "Password has been reset."
      redirect_to @user
    else
      render 'edit'                                     # （2）への対応
    end
  end
  
  private
    
    #:user必須
    #パスワード、パスワードの確認の属性をそれぞれ許可
    #それ以外は許可しない
    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end
    
    # beforeフィルタ
    
    # @userに代入　→params[:email]のメールアドレスに対応するユーザー
    def get_user
      @user = User.find_by(email: params[:email])
    end

    # 正しいユーザーかどうか確認する
    def valid_user
      # 条件がfalseの場合（@userが存在する　かつ　@userが有効化されている　かつ　@userが認証済である）
      unless (@user && @user.activated? &&
              @user.authenticated?(:reset, params[:id]))
        # root_urlにリダイレクト
        redirect_to root_url
      end
    end
    
    # トークンが期限切れかどうか確認する
    def check_expiration
      if @user.password_reset_expired?
        flash[:danger] = "Password reset has expired."
        redirect_to new_password_reset_url
      end
    end
end