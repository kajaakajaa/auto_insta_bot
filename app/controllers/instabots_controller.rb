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

  # instabot_good_path POST
  def good
    binding.pry
    if !Instabot.exists?(user_id: current_user.id)
      @rcd = Instabot.new
      @rcd.good = params[:instabot][:good]
      @rcd.user_id = current_user.id
      @rcd.save
    else
      @rcd = Instabot.find_by(user_id: current_user.id)
      @rcd.good = params[:instabot][:good]
      @rcd.update(auto_params)
    end
    key_word = "oneokrock"
    number = 3
    good_hashtag(key_word, number)
  end

  def follow
    binding.pry
    if !Instabot.exists?(user_id: current_user.id)
      @rcd = Instabot.new
      @rcd.follow = params[:instabot][:follow]
      @rcd.user_id = current_user.id
      @rcd.save
    else
      @rcd = Instabot.find_by(user_id: current_user.id)
      @rcd.follow = params[:instabot][:follow]
      @rcd.update(auto_params)
    end
    key_word = "oneokrock"
    auto_follow(key_word)
  end

  private
  def instabot_params
    params.require(:session).permit(:user_name, :password)
  end

  def auto_params
    params.require(:instabot).permit(:good, :follow).merge(user_id: current_user.id)
  end
end
