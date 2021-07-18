module InstabotAction
  extend ActiveSupport::Concern
  included do
    def insta_sign_in
      username = @auth.user_name
      password = @auth.password

      if password.length >= 6 && username.length >= 1
        Selenium::WebDriver::Chrome::Service
        # 送信側のos状況をまとめたもの
        ua = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3538.102 Safari/537.36'
        # シークレットモード
        caps = Selenium::WebDriver::Remote::Capabilities.chrome('goog:chromeOptions' => { args: ["--headless", "--user-agent=#{ua}", 'window-size=1280x800', '--incognito'] })
        client = Selenium::WebDriver::Remote::Http::Default.new
        client.read_timeout = 300
        @driver = Selenium::WebDriver.for :chrome, http_client: client, desired_capabilities: caps
        @driver.navigate.refresh
        @driver.manage.timeouts.implicit_wait = 30
        @driver.navigate.to'https://www.instagram.com/accounts/login/?source=auth_switcher'
        @driver.find_element(:name, 'username').send_keys(username)
        @driver.find_element(:name, 'password').send_keys(password)
        @driver.find_element(:name, 'password').send_keys(:return)
        sleep 5
        
        # 指定ハッシュタグにイイねをつける
        if @driver.current_url == "https://www.instagram.com/accounts/onetap/?next=%2F"
          flash[:notice] = "インスタグラムへログイン致しました。"
          redirect_to root_path
          # sleep 5
          # key_word = "oneokrock"
          # self.good_hashtag(key_word, 3)
        else
          flash.now[:error] = "正しいユーザーID、又はパスワードを再入力下さい。"
          render action: :sign_in
        end
      else
        flash.now[:error] = "空での送信不可、又はパスワードは６文字以上で入力下さい。"
        render action: :sign_in
      end
    end

    def good_hashtag(key_word,number)
      encode_word = URI.encode_www_form_component(key_word)
      sleep 3
      @driver.navigate.to"https://www.instagram.com/explore/tags/#{encode_word}/"
      sleep 3
      # 自動フォローの呼び出し
      self.follow
      sleep 3
      # unfollow
      # sleep 3
      @driver.execute_script("document.querySelectorAll('article img')[9].click()")
      sleep 3
      number.times{
        svg = @driver.find_element(:xpath, "//span[1]/button/div/span/*[name()='svg']")
        if svg.attribute("aria-label") == "いいね！" || svg.attribute("fill") == "#262626"
          @driver.execute_script("document.querySelectorAll(`button.wpO6b`)[1].click()")
          sleep 3
        else
          puts "この記事には既にイイねが付いています"
        end      
        sleep 3
        @driver.execute_script("document.querySelector('a.coreSpriteRightPaginationArrow').click()")
        sleep 3
      }
    end

    def follow
      begin
        @driver.execute_script("document.querySelector(`button.y3zKF`).click()")
      rescue
        puts "このタグは既にフォロー済みです"
      end
    end

    def unfollow
      begin
        @driver.execute_script("document.querySelector(`button._8A5w5`).click()")
      rescue
        puts "このタグは既にフォロー解除済みです"
      end
    end
  end
end