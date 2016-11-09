require 'active_record'
require 'yaml'
require 'erb'
require 'logger'

desc "Migrate database"
namespace :db do
  task migrate: :environment do
    ActiveRecord::Migrator.migrate('database/migrations', ENV['VERSION'] ? ENV['VERSION'].to_i : nil)
  end

  task rollback: :environment do
    ActiveRecord::Migrator.rollback('database/migrations')
  end

  task :environment do
    config = YAML.load(ERB.new(File.read('database/config.yml')).result)
    ActiveRecord::Base.establish_connection(config['db']['development'])
    ActiveRecord::Base.logger = Logger.new('database/database_logs.log')
  end
end

task :hello do
  puts "hello"
end
