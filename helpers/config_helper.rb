require 'selenium-webdriver'
require 'rspec'
require 'capybara'
require 'capybara/dsl'
require 'spreadsheet'
require 'browserstack/local'


include Capybara::DSL
include RSpec::Matchers

Capybara.configure do |config|
 config.default_selector = :css
 config.default_max_wait_time = 10
end

USER_NAME = ENV['BROWSERSTACK_USERNAME']
ACCESS_KEY = ENV['BROWSERSTACK_ACCESS_KEY']
# Browser_version = ENV['Browser_version']
# ACCESS_KEY = ENV['BROWSERSTACK_ACCESS_KEY']
# ACCESS_KEY = ENV['BROWSERSTACK_ACCESS_KEY']
# ACCESS_KEY = ENV['BROWSERSTACK_ACCESS_KEY']


def run_session_remote
	url = "https://#{USER_NAME}:#{ACCESS_KEY}@hub-cloud.browserstack.com/wd/hub"
	p url
	capabilities = Selenium::WebDriver::Remote::Capabilities.new
	capabilities['browser_version'] = ENV['BROWSER_VERSION']
	capabilities['browser'] = ENV['BROWSER']
	capabilities['os'] = ENV['OS']
	capabilities['os_version'] = ENV['OS_VERSION']
	capabilities['name'] = "browser_stack_assignment_1"
	capabilities['build'] = ENV["BUILD_NAME"]
	capabilities['javascriptEnabled'] = 'true'
  	Capybara.default_driver = :browserstack
	Capybara.register_driver :browserstack do |app|
		Capybara::Selenium::Driver.new(app, :browser => :remote,
		:url => url,
		:options => capabilities)	
	end
end

def setup_local_driver browser
	client = Selenium::WebDriver::Remote::Http::Default.new
	client.read_timeout = 600 # instead of the default 60
    case browser
	when "firefox"
		Capybara.default_driver = :selenium
		Capybara.register_driver :selenium do |app|
			Capybara::Selenium::Driver.new(app, :browser => :firefox,  http_client: client)
		end
    when "chrome"
		Capybara.default_driver = :chrome
		Capybara.register_driver :chrome do |app|
			chromeoptions = Selenium::WebDriver::Chrome::Options.new
			chromeoptions.add_argument('start-maximized')
			chromeoptions.add_argument('disable-infobars')
			chromeoptions.add_argument('excludeSwitches')
			Capybara::Selenium::Driver.new(app, :browser => :chrome, options: chromeoptions,  http_client: client)
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
	p "inside"
	# setup_local_driver 'chrome'
	run_session_remote
	
	config.around(:example) do |example|
		begin
		  example.run
		end
	end
	
	config.after(:each) do
		Capybara.current_session.driver.quit
	end
end