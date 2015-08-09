Rails.application.routes.draw do

  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do

    # special routes for the signup to basic newsletter
    post '/email_verification' => 'signups#email_verification'
    get '/email_confirmation' => 'signups#email_confirmation'
    # contact forms
    resources :contacts
    # Mailing list records for admin
    resources :details # deprecated. Should disappear soon.
    # for public viewing and admin editing
    resources :members
    # for user to edit and view privately
    resource :profile, only: [ :show, :edit, :update ]
    get 'profile_history' => 'profiles#history'

  end

end
