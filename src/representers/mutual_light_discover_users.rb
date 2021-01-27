# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json/hal'

require 'representers/user'

# MutualLightDiscoverUsersRepresenter represents a collection of users
# who have recently seen the light as well ;)
# Including all lights that were involved
class MutualLightDiscoverUsersRepresenter < Roar::Decorator
  include Roar::JSON::HAL

  collection :mac_addresses
  collection :users, extend: UserRepresenter
end
