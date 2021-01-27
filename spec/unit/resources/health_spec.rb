# frozen_string_literal: true

describe 'GET /health' do
  include Rack::Test::Methods

  it 'returns a boolean for the healthy status' do
    get('/health')

    last_response_json = MultiJson.load(last_response.body, symbolize_keys: true)
    expect(last_response_json[:healthy]).to be true
  end
end
