class InstabotsController < ApplicationController
  include InstabotAction
  include AjaxHelper

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
    key_word = "oneokrock"
    number = 3


    #いいねの自動化処理
      #初めての'on'時
    if !Instabot.exists?(user_id: current_user.id)
      @rcd = Instabot.new
      if @rcd.good.to_s != params[:instabot][:good]
        @rcd.good = params[:instabot][:good]
        @rcd.user_id = current_user.id
        @rcd.save
        good_hashtag(key_word, number)
      else
        puts "自動いいねは既に'#{@rcd.good}'です"
      end
    else #更新時
      @rcd = Instabot.find_by(user_id: current_user.id)
      if @rcd.good.to_s != params[:instabot][:good]
        good_val = params[:instabot][:good]
        @rcd.update_attribute(:good, good_val)

        good_hashtag(key_word, number)
      else
        puts "自動いいねは既に'#{@rcd.good}'です"
      end
    end


    #フォロー自動化処理
      #初めての'on'時
    if !Instabot.exists?(user_id: current_user.id)
      @rcd = Instabot.new
      @rcd.follow = params[:instabot][:follow]
      @rcd.user_id = current_user.id
      @rcd.save
      auto_follow(key_word)
    else #更新時
      @rcd = Instabot.find_by(user_id: current_user.id)
      if @rcd.follow.to_s != params[:instabot][:follow]
        follow_val = params[:instabot][:follow]
        @rcd.update_attribute(:follow, follow_val)

        auto_follow(key_word)
      else
        puts "自動フォローは既に'#{@rcd.follow}'です"
      end
    end


    #アンフォロー自動化処理
      #初めての'on'時
    if !Instabot.exists?(user_id: current_user.id)
      @rcd = Instabot.new
      @rcd.unfollow = params[:instabot][:unfollow]
      @rcd.user_id = current_user.id
      @rcd.save
      auto_unfollow(key_word)
    else #更新時
      @rcd = Instabot.find_by(user_id: current_user.id)
      if @rcd.unfollow.to_s != params[:instabot][:unfollow]
        unfollow_val = params[:instabot][:unfollow]
        @rcd.update_attribute(:unfollow, unfollow_val)

        auto_unfollow(key_word)
      else
        puts "自動アンフォローは既に'#{@rcd.unfollow}'です"
      end
    end
  end

  def hashtag
    binding.pry
    hashtag = params[:instabot][:hashtag]
  end

  private
  def instabot_params
    params.require(:session).permit(:user_name, :password)
  end

  def auto_params
    params.require(:instabot).permit(:good, :follow).merge(user_id: current_user.id)
  end
end
