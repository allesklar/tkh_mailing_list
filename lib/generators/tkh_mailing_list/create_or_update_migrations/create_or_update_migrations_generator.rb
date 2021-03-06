require 'rails/generaTors/migration'

module TkhMailingList
  module Generators
    class CreateOrUpdateMigrationsGenerator < ::Rails::Generators::Base
      include Rails::Generators::Migration
      source_root File.expand_path('../templates', __FILE__)
      desc "add the migrations and locale files"
      def self.next_migration_number(path)
        unless @prev_migration_nr
          @prev_migration_nr = Time.now.utc.strftime("%Y%m%d%H%M%S").to_i
        else
          @prev_migration_nr += 1
        end
        @prev_migration_nr.to_s
      end

      def copy_migrations
        puts 'creating teacher and profile migrations'
        migration_template "add_teacher_status_to_users.rb", "db/migrate/add_teacher_status_to_users.rb"
        migration_template "add_profile_fields_to_users.rb", "db/migrate/add_profile_fields_to_users.rb"
        migration_template "create_contacts.rb", "db/migrate/create_contacts.rb"
        migration_template "create_mailings.rb", "db/migrate/create_mailings.rb"
      end

    end
  end
end
