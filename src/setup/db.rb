# frozen_string_literal: true

require 'sequel'

Sequel::Model.plugin :timestamps, update_on_create: true

DATABASE_URL = ENV.fetch('DATABASE_URL')

DB = Sequel.connect(DATABASE_URL)
DB.extension(:pg_enum)
DB.extension(:pg_array)

# Require all models
models_glob = File.expand_path('../models/*.rb', __dir__)
Dir[models_glob].sort.each do |model|
  require model
end
