# frozen_string_literal: true

require 'models/discovered_lights'

describe Browse::Models::DiscoveredLights do
  describe 'storing mac addresses' do
    let(:user) { create(:user) }

    it 'stores the downcased version of the mac address' do
      discovered_light = described_class.create(mac: 'A1:5E:DE:73:CA:C7', user: user)

      expect(discovered_light.mac).to eq 'a1:5e:de:73:ca:c7'
    end

    it 'converts dashes to ":" as mac seperation marker' do
      discovered_light = described_class.create(mac: 'a1-5e-de-73-ca-c7', user: user)

      expect(discovered_light.mac).to eq 'a1:5e:de:73:ca:c7'
    end
  end

  describe 'recent mutual light discoveries' do
    let(:user1) { create(:user) }
    let(:user2) { create(:user) }

    it 'returns discoveries for the same light as the user discovered' do
      discovered_light1 = create(:discovered_light, user: user1)
      discovered_light2 = create(:discovered_light, user: user2, mac: discovered_light1.mac)
      create(:discovered_light, user: user2) # unrelated light discovery

      result = described_class.recent_mutual_discovered_lights(user_id: user1.id)
      expect(result.map(&:id)).to eq [discovered_light2.id]
    end

    it 'only returns discovered lights that have a mutual discovery with another user' do
      discovered_light1 = create(:discovered_light, user: user1)
      discovered_light2 = create(:discovered_light, user: user2, mac: discovered_light1.mac)
      create(:discovered_light, user: user1) # no mutually discovered light

      result = described_class.recent_mutual_discovered_lights(user_id: user1.id)
      expect(result.map(&:id)).to eq [discovered_light2.id]
    end

    it 'only returns mutual connections for the given user' do
      discovered_light1 = create(:discovered_light, user: user1)
      create(:discovered_light, user: user2, mac: discovered_light1.mac) # not matching

      user3 = create(:user)

      result = described_class.recent_mutual_discovered_lights(user_id: user3.id)
      expect(result.count).to be_zero
    end

    it 'only returns mutual discoveries for light discovered recently by the user' do
      discovered_light1 = create(:discovered_light, user: user1, created_at: Time.parse('1970-01-01'))
      create(:discovered_light, user: user2, mac: discovered_light1.mac)

      result = described_class.recent_mutual_discovered_lights(user_id: user1.id)
      expect(result.count).to be_zero
    end

    it 'only returns the recent mutual discoveries by others' do
      discovered_light1 = create(:discovered_light, user: user1)
      create(:discovered_light, user: user2,
                                mac: discovered_light1.mac,
                                created_at: Time.parse('1970-01-01'))

      result = described_class.recent_mutual_discovered_lights(user_id: user1.id)
      expect(result.count).to be_zero
    end
  end
end
