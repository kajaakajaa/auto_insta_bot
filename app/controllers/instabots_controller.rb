class InstabotsController < ApplicationController
  include InstabotAction

  # instabots_path GET
  def sign_in
    @auth = Instabot.new
  end
  
  # instabots_path POST
  def create
    # @auth = Instabot.new(instabot_params)
    session[:instabot] = Instabot.new(instabot_params)
    insta_sign_in

    #createに置くと正常に動く
    # key_word = "oneokrock"
    # good_hashtag(key_word,3)
  end

  # instabot_good_path POST
  def good
    @instabot = Instabot.new(good_params)

    key_word = "oneokrock"
    number = 3

    if @instabot.good == true
      good_hashtag(key_word,number)
    end
  end

  private
  def instabot_params
    params.require(:session).permit(:user_name, :password)
  end

  def good_params
    params.require(:session).permit(:good)
  end
end


