class AutomationsController < PagesContorller
  def initialize(username,password)
    Selenium::WebDriver::Chrome::Service
    ua = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3538.102 Safari/537.36'
    caps = Selenium::WebDriver::Remote::Capabilities.chrome('goog:chromeOptions' => { args: ["--user-agent=#{ua}", 'window-size=1280x800', '--incognito'] }) # シークレットモード
    client = Selenium::WebDriver::Remote::Http::Default.new
    client.read_timeout = 300
    @driver = Selenium::WebDriver.for :chrome, desired_capabilities: caps, http_client: client
    @driver.manage.timeouts.implicit_wait = 30
    @driver.navigate.to'https://www.instagram.com/accounts/login/?source=auth_switcher'
    @driver.find_element(:name, 'username').send_keys(username)
    @driver.find_element(:name, 'password').send_keys(password)
    @driver.find_element(:name, 'password').send_keys(:return)
    sleep 7
  end
end

username = "egobaowner"
password = "egoba1"
AutomationsController.new(username, password)
