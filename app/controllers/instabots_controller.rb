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
    @auto = Instabot.new(auto_params)
    rcd = Instabot.find_by(user_id: auto_params[:user_id])
    if !Instabot.exists?(user_id: auto_params[:user_id])
      @auto.save
    else
      rcd.update(auto_params)
    end
    @instabot_rcd = Instabot.find_by(user_id: current_user.id)
    key_word = "oneokrock"
    number = 3
    good_hashtag(key_word, number)
    follow(key_word)
  end

  private
  def instabot_params
    params.require(:session).permit(:user_name, :password)
  end

  def auto_params
    params.require(:instabot).permit(:good, :follow).merge(user_id: current_user.id)
  end
end


