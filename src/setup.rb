# frozen_string_literal: true

%w[
  DATABASE_URL
].each { |env| raise LoadError, "Missing: #{env}" if ENV[env].to_s.empty? }

ROOT_DIR = File.expand_path('.', __dir__)
$LOAD_PATH.unshift ROOT_DIR

require 'setup/db'
