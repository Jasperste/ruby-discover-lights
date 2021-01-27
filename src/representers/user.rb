# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json/hal'

# User representer represents a user (domain) object
class UserRepresenter < Roar::Decorator
  include Roar::JSON::HAL

  property :username
  property :created_at, render_nil: false, getter: lambda { |options|
    options[:represented].created_at&.utc&.iso8601
  }
end
