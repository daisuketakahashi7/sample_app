class UsersController < ApplicationController
  
  def show
    @user = User.find(params[:id])
  end
  
  def new
    #newアクションに@user変数を追加する
    @user = User.new
  end
  
  def create
      # createアクションでStrong Parametersを使う
    @user = User.new(user_params)
    if @user.save
      # 保存の成功をここで扱う
      flash[:success] = "Welcome to the Sample App!"     # ユーザー登録ページにフラッシュメッセージを追加する
      redirect_to @user      # 保存とリダイレクトを行う、userのcreateアクション
    else
      render 'new'
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
end
