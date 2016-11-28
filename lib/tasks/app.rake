namespace :system do

  task :pull => :environment do
    raise "Don't run this in production" unless Rails.env.development?

    database = ActiveRecord::Base.connection.current_database
    heroku_config = JSON.parse(`curl -s -n -H "Accept: application/vnd.heroku+json; version=3" https://api.heroku.com/apps/equipe-ffe/config-vars`)
    database_url = heroku_config['DATABASE_URL']

    file_path = Rails.root.join('tmp', 'db.sql')
    puts 'Downloading database dump'
    system "pg_dump --no-owner --file=#{file_path} '#{database_url}'"
    puts 'Importing meeting'
    system "psql -d #{database} -f #{file_path}"
    file_path.delete
  end

end
