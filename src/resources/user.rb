# frozen_string_literal: true

require 'container'
require 'resources/base'
require 'representers/mutual_light_discover_users'

module Browse
  module Resources
    # UserResource is the root for user related requests
    class UserResource < Base
      get '/:username/mutual_light_discover_users' do |username|
        user = Models::User[username: username]

        halt 404, 'User does not exist' if user.nil?

        discovers = Models::DiscoveredLights.recent_mutual_discovered_lights(user_id: user.id)

        content_type 'application/json'

        representer_data = Struct.new(:users, :mac_addresses)
                                 .new(discovers.eager(:user).map(&:user),
                                      discovers.map(&:mac))

        MutualLightDiscoverUsersRepresenter.new(representer_data).to_json
      end

      post '/:username/encountered_lights' do |username|
        user = Models::User[username: username]

        halt 404, 'User does not exist' if user.nil?

        # optionally validate mac address
        discovered_lights.store(user_id: user.id, macs: request_body[:MACs])

        201
      end

      # Temporary to create users
      post '/:username/new' do |username|
        halt 422, 'User already exists' unless Models::User[username: username].nil?

        Models::User.create(username: username)

        201
      end

      private

      def request_body
        JSON.parse(request.body.read, symbolize_names: true)
      end

      def authorized?
        true # for this resource we for now do not check authorization
      end

      def discovered_lights
        Container.resolve('repositories.discovered_lights')
      end
    end
  end
end
