# frozen_string_literal: true

FactoryBot.define do
  factory :user, class: 'Browse::Models::User' do
    uuid { SecureRandom.uuid }
    sequence(:username) { |n| "user#{n}" }

    to_create(&:save)
  end
end
