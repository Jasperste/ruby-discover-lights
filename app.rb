# frozen_string_literal: true

require_relative 'src/setup'
require 'sinatra/base'

resources = './src/resources/*.rb'
repositories = './src/repositories/*.rb'
# middleware = './src/middleware/*.rb'

Dir.glob(resources).sort.each { |file| require file }
Dir.glob(repositories).sort.each { |file| require file }
# Dir.glob(middleware).sort.each { |file| require file } # enable if you want to use the authentication layer

module Browse
  # App provides the base structure for the application
  class App < Sinatra::Base
    def self.routes
      @app ||= Rack::Builder.new do # rubocop:disable Naming/MemoizedInstanceVariableName
        # use Browse::Middleware::Authentication

        map '/health' do
          run Browse::Resources::HealthResource
        end

        map '/user' do
          run Browse::Resources::UserResource.new
        end
      end
    end
  end
end
