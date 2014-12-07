require "rubygems"
require "spork"


Spork.prefork do
  RACK_ENV = "test"
  ENV["RACK_ENV"] = "test"
  ENV["AUTODOC"] = "1"
  require "bundler"
  # Load the app
  require "rspec"
  require "rack/test"
  require "database_cleaner"
  require "vcr"
  Bundler.require(:default, ENV["RACK_ENV"].to_sym)
  require "simplecov"
  SimpleCov.start :test_frameworks do
    add_group "Models", "app/models"
    add_group "Controllers", "app/controllers"
    add_group "Helpers", "app/helpers"
    add_group "Mailers", "app/mailers"
    add_group "Workers", "app/workers"
    add_group "Services", "app/services"
    add_group 'Libraries', 'lib'
    add_filter "/vendor/bundle/"
    add_filter "/lib/"
    add_filter "/db/"
    add_filter "/config/initializers"
  end
  require "action_dispatch"
  require "./config/boot.rb"
  # if ActiveRecord::Migrator.needs_migration?
  #   ActiveRecord::Migrator.migrate(File.join(File.dirname(__FILE__), '../db/migrate'))
  # end
  require "faker"
  require "factory_girl"
  require "shoulda"
  require "shoulda-matchers"
  # require File.join(File.dirname(__FILE__), "support", "shared_connection.rb")
  require File.join(File.dirname(__FILE__), "support", "deferred_garbage_collection.rb")
  require File.join(File.dirname(__FILE__), "support", "vcr.rb")

  require 'capybara/rspec'
  require 'capybara/dsl'
  require 'capybara/poltergeist'


  FactoryGirl.find_definitions

  Autodoc.configuration.toc = true

  RSpec.configure do |config|
    config.mock_with :rspec
    config.include Rack::Test::Methods
    # config.include Capybara::DSL
    # Capybara.configure do |config|
    #   config.run_server = false
    #   config.app = "app"
    # end
    # config.fixture_path = File.join(File.dirname(__FILE__), "fixtures")
    # config.use_transactional_fixtures = true
    config.treat_symbols_as_metadata_keys_with_true_values = true
    config.filter_run focus: true
    config.run_all_when_everything_filtered = true
    config.order = "random"
    config.before(:all) {
      DeferredGarbageCollection.start
      Capybara.default_selector = :css
      Capybara.javascript_driver = :poltergeist
      Capybara.default_driver = :poltergeist
      Capybara.default_wait_time = 8
      Capybara.register_driver :poltergeist do |app|
        Capybara::Poltergeist::Driver.new(app, :js_errors => false, :timeout => 60)
      end
    }
    config.after(:all) { DeferredGarbageCollection.reconsider }
    # config.before(:suite) do
    #   DatabaseCleaner.strategy = :transaction
    #   DatabaseCleaner.clean_with(:truncation)
    # end

    # config.before(:each) do
    #   DatabaseCleaner.start
    # end

    # config.after(:each) do
    #   DatabaseCleaner.clean
    # end

    config.after(:suite) do
    end
  end
end
Spork.each_run do
  FactoryGirl.reload
end