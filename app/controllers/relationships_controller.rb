class RelationshipsController < ApplicationController
  before_action :logged_in_user

  def create
    @user = User.find(params[:followed_id])
    current_user.follow(@user)
    # リクエストの種類によってブロック内のいずれか1行が実行される
    respond_to do |format|
      format.html { redirect_to @user }
      # format.js
    end
  end

  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow(@user)
    # リクエストの種類によってブロック内のいずれか1行が実行される
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end
end