class InstabotsController < ApplicationController
  include InstabotAction
  include AjaxHelper

  
  # instabots_path POST
  def create
    session[:instabot] = Instabot.new(instabot_params)
    insta_sign_in
  end

  # instabots_auto_path POST
  def auto
    hash_rcds = Hashtag.where(user_id: current_user.id)
    if hash_rcds.exists?
      number = params[:instabot][:number].to_i
      hash_rcds.each do |hash_rcd|
        key_word = hash_rcd.hashtag
      

        # 新規レコード登録
        if !Instabot.exists?(user_id: current_user.id)
          @rcd = Instabot.new
          # いいね
          if @rcd.good.to_s != params[:instabot][:good]
            @rcd.number = params[:instabot][:number]
            good_hashtag(key_word, number)
          # フォロー
          elsif @rcd.follow.to_s != params[:instabot][:follow]
            auto_follow(key_word)
            @rcd.follow = params[:instabot][:follow]
          # アンフォロー
          elsif @rcd.unfollow.to_s != params[:instabot][:unfollow]
            auto_unfollow(key_word)
            @rcd.unfollow = params[:instabot][:unfollow]
          end
          if hash_rcd == hash_rcds.last
            @rcd.user_id = current_user.id
            @rcd.save
            redirect_to root_path
          end


        # 更新時
        else
          @rcd = Instabot.find_by(user_id: current_user.id)
          good_val = params[:instabot][:good]
          number_val = params[:instabot][:number]
          follow_val = params[:instabot][:follow]
          unfollow_val = params[:instabot][:unfollow]

          # いいね
          if @rcd.good != good_val && good_val == "true"
            key_word = hash_rcd.hashtag
            good_hashtag(key_word, number)
          # フォロー
          elsif @rcd.follow.to_s != follow_val
            if follow_val == "true" && unfollow_val == "false"
              @rcd.update(follow: follow_val)
              auto_follow(key_word)
              puts "フォローを#{@rcd.follow}にしました。"
            elsif follow_val == "true" && follow_val == "true"
              flash[:error] = "'登録済みの自動フォロー解除'を解除してから再度操作下さい。"
            else
              @rcd.update(follow: follow_val)
              puts "フォローを#{@rcd.follow}にしました。"
            end
          # アンフォロー
          elsif @rcd.unfollow.to_s != unfollow_val
            if unfollow_val == "true" && follow_val == "false"
              @rcd.update(unfollow: unfollow_val)
              auto_unfollow(key_word)
              puts "アンフォローを#{@rcd.unfollow}にしました。"
            elsif unfollow_val == "true" && follow_val == "true"
              flash[:error] = "'自動フォロー'を解除してから再度操作下さい。"
            else
              @rcd.update(unfollow: unfollow_val)
              puts "アンフォローを#{@rcd.unfollow}にしました。"
            end
          end
          if hash_rcd == hash_rcds.last
            respond_to do |format|
              format.js { render ajax_redirect_to(root_path) }
            end
          end
        end
      end
    else
      flash[:error] = "ハッシュタグを追加して下さい。"
      respond_to do |format|
        format.js { render ajax_redirect_to(root_path) }
      end
    end
  end


  private
  def instabot_params
    params.require(:session).permit(:user_name, :password)
  end

end


