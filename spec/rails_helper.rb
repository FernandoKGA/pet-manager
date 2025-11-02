require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'


abort("The Rails environment is running in production mode!") if Rails.env.production?
# Uncomment the line below in case you have `--require rails_helper` in the `.rspec` file
# that will avoid rails generators crashing because migrations haven't been run yet
# return unless Rails.env.test?
require 'rspec/rails'

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

# Add additional requires below this line. Rails is not loaded until this point!

require 'rspec/rails'
require 'capybara/rspec'
require 'selenium-webdriver'
require 'securerandom'

CHROME_BINARY_PATH = begin
  candidates = [
    ENV['CHROME_PATH'],
    '/usr/bin/google-chrome',
    '/usr/bin/google-chrome-stable',
    '/usr/bin/chromium',
    '/usr/bin/chromium-browser'
  ].compact
  candidates.find { |path| File.exist?(path) && File.executable?(path) }
end

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end

RSpec.configure do |config|
  # Linha crucial para habilitar 'sign_in', 'sign_out', etc. em Request Specs
  #config.include Devise::Test::IntegrationHelpers, type: :request

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_paths = [
    Rails.root.join('spec/fixtures')
  ]
  config.fixture_paths = [Rails.root.join('spec/fixtures')]

  config.use_transactional_fixtures = true

  config.filter_rails_from_backtrace!
  config.include FactoryBot::Syntax::Methods
end

Capybara.register_driver :selenium_chrome_headless_custom do |app|
  options = Selenium::WebDriver::Options.chrome
  options.add_argument('--headless=new')
  options.add_argument('--no-sandbox')
  options.add_argument('--disable-dev-shm-usage')
  options.add_argument('--window-size=1400,900')
  options.binary = CHROME_BINARY_PATH if CHROME_BINARY_PATH

  service = Selenium::WebDriver::Service.chrome
  service.executable_path = "./config/webdrivers/chromedriver/chromedriver"

  Capybara::Selenium::Driver.new(
    app,
    browser: :chrome,
    options: options,
    service: service
  )
end

# 2. Configure o RSpec para usar o driver
RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by :rack_test 
  end

  config.before(:each, type: :system, js: true) do |example|
    unless CHROME_BINARY_PATH
      example.skip "Chrome/Chromium indisponível no ambiente de testes. Configure CHROME_PATH ou instale o navegador."
      next
    end

    driven_by :selenium_chrome_headless_custom
  end
end
