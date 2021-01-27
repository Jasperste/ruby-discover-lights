# frozen_string_literal: true

Sequel.migration do
  up do
    run 'CREATE EXTENSION IF NOT EXISTS "uuid-ossp"'

    create_table?(:users) do
      primary_key :id
      String      :username, size: 255, null: false, unique: true
      column      :uuid, :uuid, default: Sequel.function(:uuid_generate_v4)
      DateTime    :created_at, null: false, default: Sequel::CURRENT_TIMESTAMP

      index [:uuid], name: :users_uuid_key, unique: true
    end

    create_table?(:discovered_lights) do
      primary_key :id
      macaddr     :mac, null: false
      foreign_key :user_id, :users, null: false
      DateTime    :created_at, null: false, default: Sequel::CURRENT_TIMESTAMP

      index [:mac], name: :discovered_lights_mac_key, unique: false
    end
  end

  down do
    run 'DROP EXTENSION IF EXISTS "uuid-ossp"'

    # drop_table :users
    # drop_table :discovered_lights
  end
end
