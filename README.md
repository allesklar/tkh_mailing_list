# TkhMailingList

This mailing list module work with the tkh_access_control gem. It allows administrators to manage user records. Most of the functionality is yet to come.

Like all tkh gems, it's meant to be used for our projects at Ten Thousand Hours and is a part of the greater tkh\_cms gem. However if some issues or pull requests come in we are ready to extend the development efforts to help as many developers as possible.


## Installation

Add this line to your application's Gemfile

    gem 'tkh_mailing_list', "~> 0.13"

Install

    $ bundle

Configure

    $ rake tkh_mailing_list:install

Migrate the database

    $ rake db:migrate

Start your server

    $ rails s


## Upgrading

Update gem

    $ bundle update tkh_mailing_list

Update locale files and migrations

    $ rake tkh_mailing_list:update

Migrate the database if there are new migrations

    $ rake db:migrate

Start your server

    $ rails s


## Usage

To manage a record, go to the /members folder.

Programmatically, to display a fully working contact form:

    <%= render 'contacts/form' %>

To embed in any page the contact form, any site administrator can use this string:

    tkh_contact_form

You MUST hide a spam prevention field in your CSS:

    div.contact_website { display: none; }


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
