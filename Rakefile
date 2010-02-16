require 'spec/rake/spectask'

task :default => :test
task :test => :spec

if !defined?(Spec)
  puts "spec targets require RSpec"
else
  desc "Run all examples"
  Spec::Rake::SpecTask.new('spec') do |t|
    t.spec_files = FileList['spec/**/*.rb']
    t.spec_opts = ['-cfs']
  end
end

namespace :db do
  desc 'migrate the database '
  task :migrate => :environment do
    max_no = DB["select max(version) as v from schema_info"].first[:v].to_i || 1
    Sequel.extension :migration
    Sequel::Migrator.apply(DB, "#{Dir.pwd}/db/migrations", max_no)
  end

end

namespace :gems do
  desc 'Install required gems'
  task :install do
    required_gems = %w{ sinatra rspec rack-test dm-core dm-timestamps dm-validations
                        dm-aggregates haml }
    required_gems.each { |required_gem| system "sudo gem install #{required_gem}" }
  end

  desc 'clean required gems'
  task :clean do
    required_gems = %w{ sinatra rspec rack-test dm-core dm-timestamps dm-validations
                        dm-aggregates haml }
    required_gems.each { |required_gem| system "sudo gem clean #{required_gem}" }
  end
end

task :environment do
  require 'environment'
end
