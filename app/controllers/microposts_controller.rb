class MicropostsController < ApplicationController
  # 直前にlogged_in_userメソッドを実行、createとdestroyのみ実行
  before_action :logged_in_user, only: [:create, :destroy]
  # 直前にcorrect_userメソッドを実行、destroyのみ実行
  before_action :correct_user,   only: :destroy
  
  def create
    @micropost = current_user.microposts.build(micropost_params)
    @micropost.image.attach(params[:micropost][:image])
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      # createアクションに空の@feed_itemsインスタンス変数を追加
      @feed_items = current_user.feed.paginate(page: params[:page])
      render 'static_pages/home'
    end
  end

  def destroy
    @micropost.destroy
    flash[:success] = "Micropost deleted"
    # 一つ前のURLを返す、デフォルトはroot_urlなのでnilでも問題なし
    redirect_to request.referrer || root_url
  end

  private

    def micropost_params
      # micropost属性必須　content,image属性のみ変更を許可
      params.require(:micropost).permit(:content, :image)
    end
    
    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end
end
