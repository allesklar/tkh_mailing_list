namespace :tkh_mailing_list do
  desc "Create migrations and locale files"
  task :install do
    system 'rails g tkh_mailing_list:create_or_update_migrations'
    system 'rails g tkh_mailing_list:create_or_update_locales -f'
  end

  desc "Update files. Skip existing migrations. Force overwrite locales"
  task :update do
    system 'rails g tkh_mailing_list:create_or_update_migrations -s'
    system 'rails g tkh_mailing_list:create_or_update_locales -f'
  end

  # this task is invoked my crontab once a day
  desc "Send to the administrators a email digest of important activities."
  task :daily_admin_digest => :environment do
    Administration.send_daily_digest
  end
end
