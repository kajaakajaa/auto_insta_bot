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
      number = params[:instabot][:number].to_i
      hash_rcds.each do |hash_rcd|
        key_word = hash_rcd.hashtag
      

        # 新規レコード登録
        if !Instabot.exists?(user_id: current_user.id)
          @rcd = Instabot.new
          # いいね
          if @rcd.good.to_s != params[:instabot][:good]
            @rcd.good = params[:instabot][:good]
            @rcd.number = params[:instabot][:number]
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
            puts "いいね'上限数'は'#{@rcd.number}'です。"
            puts "フォローは'#{@rcd.follow}'です。"
            puts "アンフォローは'#{@rcd.unfollow}'です。"
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
            now = Time.now
            end_time = now + 240
            while Time.now < end_time && good_val == "true" do
              binding.pry
              # 改めてeach do処理をかける。
              hash_rcds.each do |hash_rcd|
                key_word = hash_rcd.hashtag
                good_hashtag(key_word, number)
                if hash_rcd == hash_rcds.last
                  @rcd.update(good: good_val, number: number_val)
                  sleep 20
                end
              end
            end

          # フォロー
          elsif @rcd.follow.to_s != follow_val
            # フォロー・アンフォローの被り阻止
            if follow_val == "true" && @rcd.unfollow == true
              flash[:error] = "'登録済みの自動フォロー解除'をoffにしてから再度操作して下さい。"
              respond_to do |format|
                format.js { render ajax_redirect_to(root_path) }
              end
              break
            else
              auto_follow(key_word)
            end

          # アンフォロー
          elsif @rcd.unfollow.to_s != unfollow_val
            # フォロー・アンフォローの被り阻止
            if unfollow_val == "true" && @rcd.follow == true
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
            @rcd.update(good: good_val, number: number_val, follow: follow_val, unfollow: unfollow_val)
            puts "自動化スイッチを更新しました。"
            puts "自動いいねは'#{@rcd.good}'です。"
            puts "いいね'上限数'は'#{@rcd.number}'です。"
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


