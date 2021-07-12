class InstabotsController < ApplicationController
  def index
    @auth = Instabot.new
  end

  def create
    @auth = Instabot.new(instabot_params)
  end
  
  private
  def instabot_params
    params.require(:instabot).permit(:user_name, :password).merge(user_id: current_user.id)
  end
end
