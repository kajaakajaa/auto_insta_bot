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
    # session[:instabot]["good"] = good_params[:good]
    # @good = Instabot.new(good_params)
    @good = current_user.instabots.build(good_params)
    binding.pry
    render root_path
    
    @key_word = "oneokrock"
    @number = 3
    insta_sign_in
  end

  private
  def instabot_params
    params.require(:session).permit(:user_name, :password)
  end

  def good_params
    params.require(:instabot).permit(:good)
  end
end


