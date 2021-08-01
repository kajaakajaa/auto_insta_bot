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

      if hash_rcd != hash_rcds[0]
        break
      end

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
            puts "自動いいねは既に'#{@rcd.good}'です。"
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
          # 今渡ったデータとレコードのデータがもし違うならの判定
          if @rcd.follow.to_s != params[:instabot][:follow] || hash_rcd != hash_rcds[0] && @rcd.follow == params[:instabot][:follow]
            follow_val = params[:instabot][:follow]
            @rcd.update_attribute(:follow, follow_val)

            if @rcd.follow == true && @rcd.unfollow == true
              flash[:error] = "'フォロー' 又は 'アンフォロー'のいずれかをoffにしてから再度操作して下さい。"
              @rcd.update_attribute(:follow, !@rcd.follow)
              respond_to do |format|
                format.js { render ajax_redirect_to(root_path) }
              end
              
              break
            elsif @rcd.follow == true && @rcd.unfollow == false
              auto_follow(key_word)
            else
              puts "自動フォローは#{@rcd.follow}です。"
            end
            
          else
            puts "自動フォローは既に'#{@rcd.follow}'です。"
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

          # 今渡ったデータとレコードのデータがもし違うならの判定
          if @rcd.unfollow.to_s != params[:instabot][:unfollow]
            unfollow_val = params[:instabot][:unfollow]
            @rcd.update_attribute(:unfollow, unfollow_val)

            if @rcd.unfollow == true && @rcd.follow == true
              flash[:error] = "'フォロー' 又は 'アンフォロー'のいずれかをoffにしてから再度操作して下さい。"
              @rcd.update_attribute(:unfollow, !@rcd.unfollow)
              respond_to do |format|
                format.js { render ajax_redirect_to(root_path) }
              end
              
              break
            elsif @rcd.unfollow == true && @rcd.follow == false
              auto_follow(key_word)
            else
              puts "自動アンフォローは#{@rcd.unfollow}です。"
            end
            
          else
            puts "自動アンフォローは既に'#{@rcd.unfollow}'です。"
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
    @hash_rcd.save
    respond_to do |format|
      format.js { render ajax_redirect_to(root_path) }
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
