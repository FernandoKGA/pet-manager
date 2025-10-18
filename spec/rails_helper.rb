require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'


abort("The Rails environment is running in production mode!") if Rails.env.production?

require 'rspec/rails'
require 'capybara/rspec'
require 'selenium/webdriver'
require 'securerandom'

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end

RSpec.configure do |config|
  config.fixture_paths = [Rails.root.join('spec/fixtures')]

  config.use_transactional_fixtures = true

  config.filter_rails_from_backtrace!
  config.include FactoryBot::Syntax::Methods
end

# Configuracao do capybara no CI/CD
Capybara.register_driver :headless_chrome do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('--headless=new') # Modo headless compatível com CI
  options.add_argument('--no-sandbox')
  options.add_argument('--disable-dev-shm-usage')
  options.add_argument('--disable-gpu')
  options.add_argument('--disable-software-rasterizer')
  options.add_argument('--window-size=1400,1400')
  options.add_argument("--user-data-dir=/tmp/chrome-user-data-#{SecureRandom.hex(8)}")

  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end


Capybara.javascript_driver = :headless_chrome
Capybara.default_driver = :headless_chrome
