Rails.application.routes.draw do

  # starting with the normal translated routes
  unless  Gem::Specification::find_all_by_name('route_translator').any?

    scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do
      # special routes for the signup to basic newsletter
      post '/email_verification' => 'signups#email_verification'
      get '/email_confirmation' => 'signups#email_confirmation'
      # contact forms
      resources :contacts
      # Mailing list records for admin
      resources :details # deprecated. Should disappear soon.
      # for public viewing and admin editing
      resources :members do
        member do
          get   :unsubscribe_from_newsletter
          post  :validate_email
        end
        collection do
          post :search
        end
      end
      # for user to edit and view privately
      resource :profile, only: [ :show, :edit, :update ]
      get 'profile_history' => 'profiles#history'
      resources :mailings do
        member do
          get   :sendit
          post  :duplicate
        end
      end
    end

  else # special routing for localized routes via the route_translator gem

    localized do
      # special routes for the signup to basic newsletter
      post '/email_verification' => 'signups#email_verification'
      get '/email_confirmation' => 'signups#email_confirmation'
      # contact forms
      resources :contacts
      # Mailing list records for admin
      resources :details # deprecated. Should disappear soon.
      # for public viewing and admin editing
      resources :members do
        member do
          get   :unsubscribe_from_newsletter
          post  :validate_email
        end
        collection do
          post :search
        end
      end
      # for user to edit and view privately
      resource :profile, only: [ :show, :edit, :update ]
      get 'profile_history' => 'profiles#history'
      resources :mailings do
        member do
          get   :sendit
          post  :duplicate
        end
      end
    end

  end

end
