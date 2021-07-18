class InstabotsController < ApplicationController
  include InstabotAction

  # instabots_path GET
  def sign_in
    @auth = Instabot.new
  end
  
  # instabots_path POST
  def create
    # session[:instabot] = Instabot.new(instabot_params)
    @auth = Instabot.new(instabot_params)
    insta_sign_in
  end

  private
  def instabot_params
    params.require(:instabot).permit(:user_name, :password)
  end
end


