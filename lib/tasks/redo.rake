
namespace :zepho do
  desc "Recreate the db and populate with seed data. Runs only in development mode."
  task :redo => :environment do
    if Rails.env = 'development'
      p 'Dropping database'
      Rake::Task['db:drop'].invoke
      p 'Creating database'
      Rake::Task['db:create'].invoke
      p 'Migrating database'
      Rake::Task['db:migrate'].invoke
      p 'Seeding database'
      Rake::Task['db:seed'].invoke
      p 'Done'
    else
      p 'This task can only be run in development'
    end
  end
end