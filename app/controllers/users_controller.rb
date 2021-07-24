class UsersController < ApplicationController
  include InstabotAction
  before_action :redirect, except: :top

  def index
    @good = Instabot.new
    @check = Instabot.find_by(user_id: current_user.id)
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

  # def good_params
  #   binding.pry
  #   params.require(:user).permit(:good)
  # end
end

