require 'allure-rspec'
require 'capybara'
require 'capybara/rspec'
require 'capybara/rspec/matchers'
require 'capybara/dsl'
require 'faker'
require 'logger'
require 'rspec'
require 'rspec/expectations'
require 'selenium-webdriver'
require 'site_prism'
require 'ostruct'
require_relative '../suport/page_helper.rb'

RSpec.configure do |config|
  config.before(:each) do
    config.include Capybara::DSL
  end
  config.include AllureRSpec::Adaptor
  config.include Capybara::RSpecMatchers
  config.include Pages
  config.after(:each) do |scenario|
    temp_screenshot = '/log/results/temp_screenshoot.png'
    new_screenshot = File.new(page.save_screenshot(File.join(Dir.pwd,
                                                             temp_screenshot)))
    scenario.attach_file('screenshots', new_screenshot)
  end
end

# Configura o tipo de browser
Capybara.register_driver :selenium do |app|
  Capybara::Selenium::Driver.new(
    app,
    browser: :chrome,
    desired_capabilities: Selenium::WebDriver::Remote::Capabilities.chrome(
      'chromeOptions' => { 'args' => ['--start-maximized',
                                      '--disable-infobars'] }
    )
  )
end
# Configura o link principal e qual navegador vai usar
Capybara.configure do |config|
  config.default_driver = :selenium
  config.javascript_driver = :chrome
  config.app_host = 'http://demo.automationtesting.in/'
  config.default_max_wait_time = 10
end

AllureRSpec.configure do |config|
  config.output_dir = 'log/results'
  config.clean_dir = true
  config.logging_level = Logger::WARN
end
