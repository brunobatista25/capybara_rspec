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
require 'yaml'
require_relative '../suport/page_helper.rb'

env_yaml = YAML.load_file("#{Dir.pwd}/suport/rspec.yml")

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

# Escolhendo qual browser se quero chrome ou se quero firefox
# E se roda em headless ou sem headless
Capybara.register_driver :selenium do |app|
  if env_yaml['browser'].eql?('chrome')
    if env_yaml['headless'].eql?('headless')
      preferences = { credentials_enable_service: false,
                      password_manager_enabled: false }
      Capybara::Selenium::Driver.new(
        app,
        browser: :chrome,
        desired_capabilities: Selenium::WebDriver::Remote::Capabilities.chrome(
          'chromeOptions' => { 'args' => ['headless', 'disable-gpu',
                                          '--disable-infobars',
                                          'window-size=1600,1024'],
                               'prefs' => preferences }
        )
      )
    elsif env_yaml['headless'].eql?('no_headless')
      Capybara::Selenium::Driver.new(
        app,
        browser: :chrome,
        desired_capabilities: Selenium::WebDriver::Remote::Capabilities.chrome(
          'chromeOptions' => { 'args' => ['--disable-infobars',
                                          'window-size=1600,1024'],
                               'prefs' => preferences }
        )
      )
    end
  elsif env_yaml['browser'].eql?('firefox')
    if env_yaml['headless'].eql?('headless')
      browser_options = Selenium::WebDriver::Firefox::Options.new(args: ['--headless'])
      Capybara::Selenium::Driver.new(
        app,
        browser: :firefox,
        options: browser_options
      )
    end
  elsif env_yaml['headless'].eql?('no_headless')
    Capybara::Selenium::Driver.new(app, browser: :firefox, marionette: true)
  end
end

Capybara.configure do |config|
  config.default_driver = :selenium
  config.app_host = 'http://demo.automationtesting.in/'
  config.default_max_wait_time = 10
end

AllureRSpec.configure do |config|
  config.output_dir = 'log/results'
  config.clean_dir = true
  config.logging_level = Logger::WARN
end
