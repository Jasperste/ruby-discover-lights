# frozen_string_literal: true

ENV['DATABASE_URL'] = 'postgres://localhost/browse_test'
ENV['RACK_ENV'] = 'test'
ENV['TZ'] = 'UTC'

require 'cucumber/rspec/doubles'
require 'date'
require 'rack/test'
require 'timecop'

require_relative '../../app'

include Rack::Test::Methods # rubocop:disable Style/MixinUsage

def app
  Browse::App.routes
end

After do
  Timecop.return
end
