class AddProfileFieldsToUsers < ActiveRecord::Migration
  # profile attributes
  def change
    add_column :users,  :portrait,             :string
    add_column :users,  :allow_newsletter,     :boolean, default: true
    add_column :users,  :allow_daily_digests,  :boolean, default: true
    add_column :users,  :website_url,          :string
    add_column :users,  :facebook_url,         :string
    add_column :users,  :twitter_handle,       :string
    add_column :users,  :google_plus_url,      :string
  end
end
