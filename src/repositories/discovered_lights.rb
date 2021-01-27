# frozen_string_literal: true

module Browse
  module Repositories
    # DiscoveredLights is able to store and fetch discovered lights based on MAC and per user
    class DiscoveredLights
      def store(user_id:, macs:)
        relations = macs.map do |mac|
          full_mac = full_mac_hash(mac)
          { mac: full_mac, user_id: user_id }
        end

        # TODO: Update timestamp on duplicate user_id+mac, instead of inserting
        Models::DiscoveredLights.multi_insert(relations)
      end

      private

      def full_mac_hash(mac)
        # The iOS app currently removes the leading zero on each seperated hex set
        mac.split(':').map do |hex|
          hex = "0#{hex}" if hex.length == 1
          hex
        end.join(':')
      end
    end
  end
end
