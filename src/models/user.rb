# frozen_string_literal: true

require 'sequel'

module Browse
  module Models
    # User is a sequel model which maps to database's User table
    class User < Sequel::Model
      one_to_many :discovered_lights
    end
  end
end
