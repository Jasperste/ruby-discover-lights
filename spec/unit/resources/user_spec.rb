# frozen_string_literal: true

describe 'GET/POST /:user/' do
  include Rack::Test::Methods

  context 'finding users who have discovered the same lights recently' do
    let(:user) { create(:user) }

    before do
      user2 = create(:user, username: 'foo', created_at: Time.parse('2021-02-21'))
      user3 = create(:user, username: 'bar', created_at: Time.parse('2011-03-21'))
      create(:discovered_light, user: user2, mac: '00:00:00:00:00:01')
      create(:discovered_light, user: user3, mac: '00:00:00:00:00:02')

      allow(Browse::Models::DiscoveredLights)
        .to receive(:recent_mutual_discovered_lights)
        .with(user_id: user.id)
        .and_return(Browse::Models::DiscoveredLights) # returns a relation
    end

    it 'returns a set of users that recently saw the same lights' do
      get("/user/#{user.username}/mutual_light_discover_users")

      last_response_json = MultiJson.load(last_response.body, symbolize_keys: true)
      expect(last_response_json).to eq(mac_addresses: ['00:00:00:00:00:01', '00:00:00:00:00:02'],
                                       users: [{ created_at: '2021-02-21T00:00:00Z', username: 'foo' },
                                               { created_at: '2011-03-21T00:00:00Z', username: 'bar' }])
    end

    it 'does not allow fetching for a non-existing user' do
      get('/user/foobar/mutual_light_discover_users')

      expect(last_response.status).to be 404
    end
  end

  context 'posting discovered lights' do
    let(:discovered_lights_repo) { instance_double(Browse::Repositories::DiscoveredLights) }

    before do
      Container.enable_stubs!
      Container.stub('repositories.discovered_lights', discovered_lights_repo)
      allow(discovered_lights_repo).to receive(:store)
    end

    it 'stores the macs linked with the user' do
      user = create(:user)
      data = JSON.dump({ "MACs": %w[A1-5E-DE-73-CA-C7 69-DD-3B-20-BB-76] })

      post("/user/#{user.username}/encountered_lights", data)

      expect(discovered_lights_repo).to have_received(:store).with(user_id: user.id,
                                                                   macs: %w[A1-5E-DE-73-CA-C7 69-DD-3B-20-BB-76])
    end

    it 'does not allow storing for a non-existing user' do
      post('/user/foobar/encountered_lights', '{}')

      expect(last_response.status).to be 404
    end
  end

  context 'calling new on the user resource' do
    it 'creates a new user' do
      username = 'user1'
      post("/user/#{username}/new")

      expect(Browse::Models::User.where(username: username).count).to eq 1
    end

    context 'with an existing user' do
      let(:username) { 'foo' }

      before do
        create(:user, username: username)
      end

      it 'halts with a 422 if the user meant to be created already exists' do
        post("/user/#{username}/new")

        expect(last_response.status).to be 422
      end
    end
  end
end
