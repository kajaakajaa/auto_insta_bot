module InstabotAction
  extend ActiveSupport::Concern
  included do
    def insta_sign_in
      username = session[:instabot]["user_name"]
      password = session[:instabot]["password"]


      Selenium::WebDriver::Chrome::Service
      # 送信側のos状況をまとめたもの
      ua = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3538.102 Safari/537.36'
      # シークレットモード
      caps = Selenium::WebDriver::Remote::Capabilities.chrome('goog:chromeOptions' => { args: ["--user-agent=#{ua}", 'window-size=1280x800', '--incognito'] })
      client = Selenium::WebDriver::Remote::Http::Default.new
      client.read_timeout = 300
      @driver = Selenium::WebDriver.for :chrome, http_client: client, desired_capabilities: caps
      @driver.manage.timeouts.implicit_wait = 30
      @driver.navigate.to'https://www.instagram.com/accounts/login/?source=auth_switcher'
      if password.length >= 6 && username.length >= 1
        @driver.find_element(:name, 'username').send_keys(username)
        @driver.find_element(:name, 'password').send_keys(password)
        @driver.find_element(:name, 'password').send_keys(:return)
        sleep 5        
        # 正しいワードかログイン判定
        if @driver.current_url == "https://www.instagram.com/accounts/onetap/?next=%2F" || @driver.current_url == "https://www.instagram.com/"
          flash[:notice] = "インスタグラムへアカウント認証致しました。"
          redirect_to root_path
          @driver.quit
        else
          flash.now[:error] = "正しいユーザーID、又はパスワードを再入力下さい。"
          render action: :sign_in
          @driver.quit
        end
      else
        flash.now[:error] = "空での送信不可、又はパスワードは６文字以上で入力下さい。"
        render action: :sign_in
        @driver.quit
      end
    end
    

    
    def good_hashtag(key_word, number)
      binding.pry
      # if params[:instabot][:good] == "true"
        username = session[:instabot]["user_name"]
        password = session[:instabot]["password"]
        
        Selenium::WebDriver::Chrome::Service
        # 送信側のos状況をまとめたもの
        ua = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3538.102 Safari/537.36'
        # シークレットモード
        caps = Selenium::WebDriver::Remote::Capabilities.chrome('goog:chromeOptions' => { args: ["--user-agent=#{ua}", 'window-size=1280x800', '--incognito'] })
        client = Selenium::WebDriver::Remote::Http::Default.new
        client.read_timeout = 300
        @driver = Selenium::WebDriver.for :chrome, http_client: client, desired_capabilities: caps
        @driver.manage.timeouts.implicit_wait = 30
        @driver.navigate.to'https://www.instagram.com/accounts/login/?source=auth_switcher'
        sleep 5
        @driver.find_element(:name, 'username').send_keys(username)
        @driver.find_element(:name, 'password').send_keys(password)
        @driver.find_element(:name, 'password').send_keys(:return)
        sleep 5
        encode_word = URI.encode_www_form_component(key_word)
        sleep 3
        @driver.navigate.to"https://www.instagram.com/explore/tags/#{encode_word}/"
        sleep 3
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
        @driver.quit
      # else
      #   puts "いいねは'#{@rcd.good}'です。"
      # end
    end


    def auto_follow(key_word)
      if params[:instabot][:follow].to_s == "true" # && @rcd.follow == false
        username = session[:instabot]["user_name"]
        password = session[:instabot]["password"]
        
        Selenium::WebDriver::Chrome::Service
        # 送信側のos状況をまとめたもの
        ua = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3538.102 Safari/537.36'
        # シークレットモード
        caps = Selenium::WebDriver::Remote::Capabilities.chrome('goog:chromeOptions' => { args: ["--user-agent=#{ua}", 'window-size=1280x800', '--incognito'] })
        client = Selenium::WebDriver::Remote::Http::Default.new
        client.read_timeout = 300
        @driver = Selenium::WebDriver.for :chrome, http_client: client, desired_capabilities: caps
        @driver.manage.timeouts.implicit_wait = 30
        @driver.navigate.to'https://www.instagram.com/accounts/login/?source=auth_switcher'
        sleep 5
        @driver.find_element(:name, 'username').send_keys(username)
        @driver.find_element(:name, 'password').send_keys(password)
        @driver.find_element(:name, 'password').send_keys(:return)
        sleep 5
        encode_word = URI.encode_www_form_component(key_word)
        sleep 3
        @driver.navigate.to"https://www.instagram.com/explore/tags/#{encode_word}/"
        sleep 3
        begin
          @driver.execute_script("document.querySelector(`button.y3zKF`).click()")
          puts "#{key_word}のタグをフォローしました。"
        rescue
          puts "#{key_word}のタグは既にフォロー済みです"
        end
        sleep 5
        @driver.quit
      else
        puts "フォローは'#{@rcd.follow}'です。（裏）"
      end
    end



    def auto_unfollow(key_word)
      if params[:instabot][:unfollow] == "true" # && @rcd.unfollow == false
        username = session[:instabot]["user_name"]
        password = session[:instabot]["password"]
        
        Selenium::WebDriver::Chrome::Service
        # 送信側のos状況をまとめたもの
        ua = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3538.102 Safari/537.36'
        # シークレットモード
        caps = Selenium::WebDriver::Remote::Capabilities.chrome('goog:chromeOptions' => { args: ["--user-agent=#{ua}", 'window-size=1280x800', '--incognito'] })
        client = Selenium::WebDriver::Remote::Http::Default.new
        client.read_timeout = 300
        @driver = Selenium::WebDriver.for :chrome, http_client: client, desired_capabilities: caps
        @driver.manage.timeouts.implicit_wait = 30
        @driver.navigate.to'https://www.instagram.com/accounts/login/?source=auth_switcher'
        sleep 5
        @driver.find_element(:name, 'username').send_keys(username)
        @driver.find_element(:name, 'password').send_keys(password)
        @driver.find_element(:name, 'password').send_keys(:return)
        sleep 5
        encode_word = URI.encode_www_form_component(key_word)
        sleep 3
        @driver.navigate.to"https://www.instagram.com/explore/tags/#{encode_word}/"
        sleep 3
        begin
          @driver.execute_script("document.querySelector(`button._8A5w5`).click()")
          puts "#{key_word}のタグのフォローを解除しました。"
        rescue
          puts "'#{key_word}'のタグは既にフォロー解除済みです"
        end
        sleep 5
        @driver.quit
      else
        puts "アンフォローは'#{@rcd.unfollow}'です。（裏）"
      end
    end

  end
end


