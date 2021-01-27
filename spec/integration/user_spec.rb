# frozen_string_literal: true

describe 'Updating and fetching discovered lights' do
  include Rack::Test::Methods

  context 'adding discovered lights' do
    it 'stores raw macs unified linked to the user' do
      user = create(:user)
      data = JSON.dump({ "MACs": %w[A1-5E-DE-73-CA-C7 69-DD-3B-20-BB-76] })

      post("/user/#{user.username}/encountered_lights", data)

      result = Browse::Models::DiscoveredLights.order(:mac).map { |discover| [discover.mac, discover.user_id] }
      expect(result).to eq [['69:dd:3b:20:bb:76', user.id], ['a1:5e:de:73:ca:c7', user.id]]

      expect(last_response.status).to be 201
    end
  end

  context 'retrieving users who recently saw the same lights' do
    let(:user1) { create(:user, username: 'jasperste') }
    let(:user2) { create(:user, username: 'foobar', created_at: '2021-02-21T00:00:00Z') }
    let(:user3) { create(:user) }

    it 'returns other users who saw the same lights' do
      discovered_light1 = create(:discovered_light, user: user1)
      create(:discovered_light, user: user2, mac: discovered_light1.mac)
      create(:discovered_light, user: user3) # unrelated light discovery

      get('/user/jasperste/mutual_light_discover_users')

      expect(last_response.status).to be 200

      last_response_json = MultiJson.load(last_response.body, symbolize_keys: true)
      expect(last_response_json).to eq(mac_addresses: [discovered_light1.mac],
                                       users: [{ created_at: '2021-02-21T00:00:00Z', username: 'foobar' }])
    end
  end
end
