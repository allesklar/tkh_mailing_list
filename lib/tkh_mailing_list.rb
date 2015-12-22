require "tkh_mailing_list/version"
require "roadie-rails"
require "tkh_access_control"
require "tkh_activity_feeds"
require "carrierwave"
require "rmagick"

module TkhMailingList
  class Engine < ::Rails::Engine
    initializer "TkhMailingList precompile hook", :group => :all do |app|
      app.config.assets.precompile += [ 'emails.css' ]
    end
  end
end
