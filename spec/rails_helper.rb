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
  options.add_argument('--headless=new') # Modo headless moderno
  options.add_argument('--no-sandbox')
  options.add_argument('--disable-dev-shm-usage')
  options.add_argument('--window-size=1400,900')

  service = Selenium::WebDriver::Service.chrome
  
  # Você especificou um caminho para o chromedriver, então vamos mantê-lo:
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
  # ... (suas outras configs: fixture_paths, use_transactional_fixtures, etc.)

  # Diga ao RSpec para usar seu driver customizado para testes :system
  config.before(:each, type: :system) do
    # O :rack_test é para testes rápidos (não-JS)
    # O :selenium_chrome_headless_custom é para testes com JS (como o seu)
    driven_by :rack_test 
  end

  config.before(:each, type: :system, js: true) do
    driven_by :selenium_chrome_headless_custom
  end
end