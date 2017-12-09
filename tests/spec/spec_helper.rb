require 'capybara'
require 'capybara/rspec'
require 'capybara/rspec/matchers'
require 'capybara/dsl'
require 'cucumber'
require 'faker'
require 'rspec'
require 'rspec/expectations'
require 'selenium-webdriver'
require 'site_prism'
require 'ostruct'
require_relative '../suport/helper.rb'
require_relative '../suport/page_helper.rb'

RSpec.configure do |config|
  config.include Capybara::DSL
  config.include Capybara::RSpecMatchers
  config.include Helper
  config.include Pages
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end
  config.after(:each) do |describe|
    describe_name = describe.description.gsub(/\s+/, '_').tr('/', '_')
    describe_name = describe_name.delete(',', '')
    describe_name = describe_name.delete('(', '')
    describe_name = describe_name.delete(')', '')
    describe_name = describe_name.delete('#', '')
    if describe.exception
      take_screenshot(describe_name.downcase!, 'failed')
    else
      take_screenshot(describe_name.downcase!, 'passed')
    end
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
  config.default_max_wait_time = 60
end
