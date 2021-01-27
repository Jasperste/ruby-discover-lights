# frozen_string_literal: true

require 'dry-container'
require 'dry-auto_inject'

# Container holds instances for DI
class Container
  extend Dry::Container::Mixin

  namespace('repositories') do
    register('discovered_lights') do
      require 'repositories/discovered_lights'
      Browse::Repositories::DiscoveredLights.new
    end
  end
end

Import = Dry::AutoInject(Container)
