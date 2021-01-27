# frozen_string_literal: true

require 'repositories/discovered_lights'

module Browse
  module Repositories
    describe DiscoveredLights do
      subject(:repo) { described_class.new }

      describe 'store' do
        let(:user) { create(:user) }
        let(:mac_addresses) { ['a1:5e:de:73:ca:c7', '69:dd:3b:20:bb:76'] }

        it 'stores relations of users and mac addresses' do
          subject.store(user_id: user.id, macs: mac_addresses)

          stored_mac_addresses = Models::DiscoveredLights.where(user: user).map(&:mac)
          expect(stored_mac_addresses).to eq mac_addresses
        end

        context 'with mac address missing a leading zero' do
          # the iOS app removes leading zero's in mac address, which is unified before saving
          let(:mac_addresses) { ['a1:e:e:3:a:c7'] }

          it 'adds a leading zero to the mac address before doing a insertion' do
            subject.store(user_id: user.id, macs: mac_addresses)

            stored_mac_address = Models::DiscoveredLights.where(user: user).first.mac
            expect(stored_mac_address).to eq 'a1:0e:0e:03:0a:c7'
          end
        end
      end
    end
  end
end
