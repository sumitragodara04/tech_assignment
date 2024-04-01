require 'selenium-webdriver'
require 'rspec'
require 'capybara'
require 'capybara/dsl'
require 'spreadsheet'


include Capybara::DSL
include RSpec::Matchers

Capybara.configure do |config|
 config.default_driver = :selenium
 config.default_selector = :css
 config.app_host = 'https://www.flipkart.com/'
 config.default_max_wait_time = 10
end



def setup_driver browser
	client = Selenium::WebDriver::Remote::Http::Default.new
	client.read_timeout = 600 # instead of the default 60
    case browser.downcase
	when "firefox"
		Capybara.default_driver = :selenium
		Capybara.register_driver :selenium do |app|
			Capybara::Selenium::Driver.new(app, :browser => :firefox,  http_client: client)
		end
    when "chrome"
		Capybara.register_driver :chrome do |app|
			chromeoptions = Selenium::WebDriver::Chrome::Options.new
			chromeoptions.add_argument('start-maximized')
			chromeoptions.add_argument('disable-infobars')
			chromeoptions.add_argument('excludeSwitches')
			Capybara::Selenium::Driver.new(app, :browser => :chrome, capabilities: chromeoptions,  http_client: client)
		end
  
    when  "ie"
        Capybara.default_driver = :internet_explorer
		Capybara.register_driver :internet_explorer do |app|
			Capybara::Selenium::Driver.new(app, :browser => :internet_explorer, http_client: client)
		end
    when "edge"
        Capybara.default_driver = :edge
		Capybara.register_driver :edge do |app|
			Capybara::Selenium::Driver.new(app, :browser => :edge, http_client: client)
		end
    when 'headless_chrome'
        Capybara.default_driver = :headless_chrome
        Capybara.javascript_driver = :headless_chrome
		Capybara.register_driver :headless_chrome do |app|
			options = Selenium::WebDriver::Chrome::Options.new(args: ['headless', 'window-size=1366x768'])
			Capybara::Selenium::Driver.new(app, :browser => :chrome, options: options)
		end
    else 
      raise "You must add browser name"
    end
    Capybara.current_session.driver.browser.manage.window.maximize
end

RSpec.configure do |config|
	config.before(:each) do
		setup_driver 'chrome'
	end
	
	config.around(:example) do |example|
		begin
		  example.run
		end
	end
	
	config.after(:each) do
		Capybara.current_session.driver.quit
	end
end