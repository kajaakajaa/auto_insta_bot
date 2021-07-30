class UsersController < ApplicationController
  include InstabotAction
  before_action :redirect, except: :top

  def index
    @auto = Instabot.new
    @hashtag = Hashtag.new
    #新規登録の場合（データベースにデータがまだ無い場合）
    if Instabot.exists?(user_id: current_user.id)
       @instabot_rcd = Instabot.find_by(user_id: current_user.id)
       
       session[:instabot]["good"] = @instabot_rcd.good
       session[:instabot]["follow"] = @instabot_rcd.follow
       session[:instabot]["unfollow"] = @instabot_rcd.unfollow

       @good_check = session[:instabot]["good"]
       @follow_check = session[:instabot]["follow"]
       @unfollow_check = session[:instabot]["unfollow"]
    else
       @good_check = session[:instabot]["good"]
       @follow_check = session[:instabot]["follow"]
       @unfollow_check = session[:instabot]["unfollow"]
    end
  end
 
  def top
  end
  
  def destroy
  end

  private

  def redirect
    unless user_signed_in?
      redirect_to action: :top
    end
  end

end

