class UsersController < ApplicationController
  include InstabotAction
  before_action :redirect, except: :top

  def index
    @good = Instabot.new
  end

  def create
    # @good = Instabot.new(good_params)
    # params[:instabot].each do | di1,di2 |
    #   # チェックボックスにチェックがついている場合
    #   if di2 == "1"
    #     # DBのtitleカラムにタイトルを格納し保存
    #     @good = Instabot.new(title:di1)
    #   end
    # end
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
