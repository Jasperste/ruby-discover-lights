# frozen_string_literal: true

require_relative 'base'

module Browse
  module Resources
    # Health returns if the server is healthy
    # For example can be used by Kubernetes to validate the state of the api pod
    class HealthResource < Base
      get '/' do
        content_type 'application/json'

        # TODO: Check connection with the Database
        { healthy: true }.to_json
      end

      private

      def authorized?
        true
      end
    end
  end
end
