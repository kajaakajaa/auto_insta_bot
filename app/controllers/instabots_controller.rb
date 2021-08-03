class InstabotsController < ApplicationController
  include InstabotAction
  include AjaxHelper

  
  # instabots_path POST
  def create
    session[:instabot] = Instabot.new(instabot_params)
    insta_sign_in
  end

  # instabot_auto_path POST
  def auto
    hash_rcds = Hashtag.where(user_id: current_user.id)
    if hash_rcds.exists?
      number = 3
      hash_rcds.each do |hash_rcd|
      key_word = hash_rcd.hashtag


        # 新規レコード登録
        if !Instabot.exists?(user_id: current_user.id)
          @rcd = Instabot.new
          # いいね
          if @rcd.good.to_s != params[:instabot][:good]
              puts "フォローは#{@rcd.follow}です。"
              puts "アンフォローは#{@rcd.unfollow}です。"
            @rcd.good = params[:instabot][:good]
            good_hashtag(key_word, number)
          # フォロー
          elsif @rcd.follow.to_s != params[:instabot][:follow]
              puts "自動いいねは#{@rcd.good}です。"
              puts "アンフォローは#{@rcd.unfollow}です。"
            @rcd.follow = params[:instabot][:follow]
            auto_follow(key_word) 
          # アンフォロー
          elsif @rcd.unfollow.to_s != params[:instabot][:unfollow]
              puts "自動いいねは#{@rcd.good}です。"
              puts "フォローは#{@rcd.follow}です。"
            @rcd.unfollow = params[:instabot][:unfollow]
            auto_unfollow(key_word)
          end
          if hash_rcd == hash_rcds.last
            @rcd.save
          end
        # 更新時
        else
          @rcd = Instabot.find_by(user_id: current_user.id)
          good_val = params[:instabot][:good]
          follow_val = params[:instabot][:follow]
          unfollow_val = params[:instabot][:unfollow]

          # いいね
          if @rcd.good.to_s != params[:instabot][:good]
              good_hashtag(key_word, number)
          # フォロー
          elsif @rcd.follow.to_s != params[:instabot][:follow]
            # フォロー・アンフォローの被り阻止
            if params[:instabot][:follow] == "true" && @rcd.unfollow == true
              flash[:error] = "'自動アンフォロー'をoffにしてから再度操作して下さい。"
              respond_to do |format|
                format.js { render ajax_redirect_to(root_path) }
              end

              break
            elsif params[:instabot][:follow] == "true" && @rcd.unfollow == false
              auto_follow(key_word)
            else
              auto_follow(key_word)
            end
          # アンフォロー
          elsif @rcd.unfollow.to_s != params[:instabot][:unfollow]
            # フォロー・アンフォローの被り阻止
            if params[:instabot][:unfollow] == "true" && @rcd.follow == true
              flash[:error] = "'自動フォロー'をoffにしてから再度操作して下さい。"
              respond_to do |format|
                format.js { render ajax_redirect_to(root_path) }
              end

              break
            elsif params[:instabot][:unfollow] == "true" && @rcd.unfollow == false
              auto_unfollow(key_word)
            else
              auto_unfollow(key_word)
            end
          end
          if hash_rcd == hash_rcds.last
            @rcd.update(good: good_val, follow: follow_val, unfollow: unfollow_val)
            puts "自動化スイッチを更新しました。"
            puts "自動いいねは#{@rcd.good}です。"
            puts "フォローは#{@rcd.follow}です。"
            puts "アンフォロー#{@rcd.unfollow}です。"
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

  # instabots_hashtag_path POST
  def hashtag
    @hash_rcd = Hashtag.new(hashtag_params)
    if @hash_rcd.save
      respond_to do |format|
        format.js { render ajax_redirect_to(root_path) }
      end
    else
      flash[:error] = "ハッシュタグの追加は上限２個までとなります。"
      respond_to do |format|
        format.js { render ajax_redirect_to(root_path) }
      end
    end
  end

  private
  def instabot_params
    params.require(:session).permit(:user_name, :password)
  end

  def hashtag_params
    params.require(:hashtag).permit(:hashtag).merge(user_id: current_user.id)
  end
end


