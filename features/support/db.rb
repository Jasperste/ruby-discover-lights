# frozen_string_literal: true

require 'database_cleaner'
require 'database_cleaner/cucumber'

DatabaseCleaner.strategy = :truncation
DatabaseCleaner.clean_with(:truncation)

Around('@database') do |_scenario, block|
  DatabaseCleaner.cleaning(&block)
end
