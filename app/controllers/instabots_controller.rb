class InstabotsController < ApplicationController
  include InstabotAction

  # instabots_path GET
  def sign_in
  end
  
  # instabots_path POST
  def create
    session[:instabot] = Instabot.new(instabot_params)
    insta_sign_in
  end

  # instabot_auto_path POST
  def auto
    @auto = Instabot.new(good_params)
    if !Instabot.exists?(user_id: good_params[:user_id])
      @auto.save
    else
      @instabot_rcd = Instabot.find_by(user_id: good_params[:user_id])
      @instabot_rcd.update(good_params)
    end
    key_word = "oneokrock"
    number = 3
    good_hashtag(key_word, number)
  end

  private
  def instabot_params
    params.require(:session).permit(:user_name, :password)
  end

  def good_params
    params.require(:instabot).permit(:good, :follow).merge(user_id: current_user.id)
  end
end


