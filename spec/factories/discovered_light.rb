# frozen_string_literal: true

FactoryBot.define do
  factory :discovered_light, class: 'Browse::Models::DiscoveredLights' do
    association :user

    mac { 6.times.map { format('%02x', rand(0..255)) }.join(':') }

    to_create(&:save)
  end
end
