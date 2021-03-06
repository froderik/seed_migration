require 'rails'

module SeedMigration

  class << self
    mattr_accessor :extend_native_migration_task
    mattr_accessor :migration_table_name
    mattr_accessor :ignore_ids
    mattr_accessor :update_seeds_file
    mattr_accessor :migrations_path
    mattr_accessor :use_strict_create

    self.migration_table_name = 'seed_migration_data_migrations' # Hardcoded, evil!
    self.extend_native_migration_task = false
    self.ignore_ids = false
    self.update_seeds_file = true
    self.migrations_path = 'data'
    self.use_strict_create = false
  end

  def self.config
    yield self
    after_config
  end

  def self.after_config
    if self.extend_native_migration_task
      require_relative '../extra_tasks.rb'
    end
  end

  def self.use_strict_create?
    use_strict_create
  end

  class Engine < ::Rails::Engine
    isolate_namespace SeedMigration

    config.generators do |g|
      g.test_framework :rspec, :fixture => false
      g.fixture_replacement :factory_girl, :dir => 'spec/factories'
      g.assets false
      g.helper false
    end

  end
end
