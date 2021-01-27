# frozen_string_literal: true

require 'multi_json'

Given(/^the following users:$/) do |table|
  table.hashes.each do |row|
    Browse::Models::User.create(
      username: row['username'],
      created_at: row['created_at']
    )
  end
end

Given(/^the user "([^"]*)" exists$/) do |username|
  Browse::Models::User.create(username: username)
end

When(/^a client does a GET request to "(.+)"$/) do |url|
  get(url) # http://sinatrarb.com/testing.html
end

When(/^a client does a POST request to "([^"]*)" with the following data:$/) do |url, data|
  post(url, data, 'CONTENT_TYPE' => 'application/json')
end

Then(/^the response should be JSON:$/) do |body|
  expect(MultiJson.load(last_response.body)).to eq MultiJson.load(body)
end

Then(/^the response status should be "([^"]*)"$/) do |status|
  expect(last_response.status).to eq status.to_i
end

Then(/^user "([^"]*)" should have registered "([^"]*)"$/) do |username, mac|
  user_id = Browse::Models::User[username: username].id
  relation = Browse::Models::DiscoveredLights[user_id: user_id, mac: mac]
  expect(relation).to exist
end
