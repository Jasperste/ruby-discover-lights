# frozen_string_literal: true

require 'sinatra/base'

module Browse
  module Resources
    # Base provides the desired base setup for every endpoint
    class Base < Sinatra::Base
      before do
        halt 401 unless authorized?
      end

      private

      # :reek:NilCheck
      def authorized?
        !authenticated_user_uuid.nil?
      end

      def authenticated_user_uuid
        request.env.fetch('user_uuid', nil)
      end
    end
  end
end
