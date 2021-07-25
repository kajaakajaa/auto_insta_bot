class InstabotsController < ApplicationController
  include InstabotAction

  # instabots_path GET
  def sign_in
  end
  
  # instabots_path POST
  def create
    session[:instabot] = Instabot.new(instabot_params)
    @instabot_rcd = Instabot.find_by(user_id: current_user.id)
    insta_sign_in
  end

  # instabot_good_path POST
  def auto
    @good = Instabot.new(good_params)
    @instabot_rcd = Instabot.find_by(user_id: good_params[:user_id])
    if !Instabot.exists?(user_id: good_params[:user_id])
      @good.save
    else
      @instabot_rcd.update(good_params)
    end
    @key_word = "oneokrock"
    @number = 3
    insta_sign_in
  end

  private
  def instabot_params
    params.require(:session).permit(:user_name, :password)
  end

  def good_params
    params.require(:instabot).permit(:good).merge(user_id: current_user.id)
  end
end


