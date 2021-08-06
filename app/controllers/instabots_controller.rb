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
    random = Random.new
    hash_rcds = Hashtag.where(user_id: current_user.id)
    if hash_rcds.exists?
      number = 1
      timer = 60
      hash_rcds.each do |hash_rcd|
        key_word = hash_rcd.hashtag
      

        # 新規レコード登録
        if !Instabot.exists?(user_id: current_user.id)
          @rcd = Instabot.new
          # いいね
          if @rcd.good.to_s != params[:instabot][:good]
            @rcd.good = params[:instabot][:good]
            binding.pry
            good_hashtag(key_word, number)
          # フォロー
          elsif @rcd.follow.to_s != params[:instabot][:follow]
            @rcd.follow = params[:instabot][:follow]
            auto_follow(key_word)
          # アンフォロー
          elsif @rcd.unfollow.to_s != params[:instabot][:unfollow]
            @rcd.unfollow = params[:instabot][:unfollow]
            auto_unfollow(key_word)
          end
          if hash_rcd == hash_rcds.last
            @rcd.user_id = current_user.id
            @rcd.save
            puts "自動化スイッチを新規登録しました。"
            puts "いいねは'#{@rcd.good}'です。"
            puts "フォローは'#{@rcd.follow}'です。"
            puts "アンフォローは'#{@rcd.unfollow}'です。"
          end


        # 更新時
        else
          @rcd = Instabot.find_by(user_id: current_user.id)
          good_val = params[:instabot][:good]
          follow_val = params[:instabot][:follow]
          unfollow_val = params[:instabot][:unfollow]
          # いいね
          if @rcd.good.to_s != params[:instabot][:good] && params[:instabot][:good] == "true"
            num = 0
            while num == 2 do
              # 上記の下記二行は無効の為、再度ループ処理を記述。
              hash_rcds.each do |hash_rcd|
                key_word = hash_rcd.hashtag
                good_hashtag(key_word, number)
                if hash_rcd == hash_rcds.last
                  sleep 30
                  @rcd =
                  num += 1
                end
              end
            end # いいねoffに切替
          elsif @rcd.good.to_s != params[:instabot][:good] && params[:instabot][:good] == "false"
            puts "いいねは'#{@rcd.good}'です。"
          # フォロー
          elsif @rcd.follow.to_s != params[:instabot][:follow]
            # フォロー・アンフォローの被り阻止
            if params[:instabot][:follow] == "true" && @rcd.unfollow == true
              flash[:error] = "'登録済みの自動フォロー解除'をoffにしてから再度操作して下さい。"
              respond_to do |format|
                format.js { render ajax_redirect_to(root_path) }
              end
              break
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
            else
              auto_unfollow(key_word)
            end
          end
          if hash_rcd == hash_rcds.last
            @rcd.update(good: good_val, follow: follow_val, unfollow: unfollow_val)
            puts "自動化スイッチを更新しました。"
            puts "自動いいねは'#{@rcd.good}'です。"
            puts "フォローは'#{@rcd.follow}'です。"
            puts "アンフォロー'#{@rcd.unfollow}'です。"
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


