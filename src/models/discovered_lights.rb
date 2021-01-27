# frozen_string_literal: true

require 'sequel'

module Browse
  module Models
    # DiscoveredLights contains tuples between users and discovered lights
    class DiscoveredLights < Sequel::Model
      many_to_one :user
      # many_to_one :light # a light could be a seperated model in the future

      MAX_EXPIRE_TIME = 2000

      dataset_module do
        # Returns all recent light discoveries by other users for the same lights
        # as the given user recently discovered
        def recent_mutual_discovered_lights(user_id:) # rubocop:disable Metrics/AbcSize
          where(Sequel[:discovered_lights][:user_id] => user_id)
            .exclude(Sequel[:mutual_discovered_lights][:user_id] => user_id)
            .inner_join(Sequel[:discovered_lights].as(:mutual_discovered_lights),
                        mac: Sequel[:discovered_lights][:mac])
            .where { Sequel[:discovered_lights][:created_at] > Time.now - MAX_EXPIRE_TIME }
            .where { Sequel[:mutual_discovered_lights][:created_at] > Time.now - MAX_EXPIRE_TIME }
        end
      end
    end
  end
end
