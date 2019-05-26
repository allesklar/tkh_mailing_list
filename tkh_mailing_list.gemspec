# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tkh_mailing_list/version'

Gem::Specification.new do |spec|
  spec.name          = "tkh_mailing_list"
  spec.version       = TkhMailingList::VERSION
  spec.authors       = ["Swami Atma"]
  spec.email         = ["swamiatma@yoga108.org"]
  spec.description   = %q{A mailing list module to work with tkh_authentication gem}
  spec.summary       = %q{This gem inherits from the tkh_access_control gem and allows administrators to manage user records}
  spec.homepage      = "https://github.com/allesklar/tkh_mailing_list"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"

  # temporarily, until roadie-rails reaches 1.1
  # a spceial fork needs to be used from the host app:
  # gem 'roadie-rails', git: 'https://github.com/tomasc/roadie-rails'
  spec.add_dependency 'roadie-rails'
  spec.add_dependency 'tkh_access_control'
  spec.add_dependency 'tkh_activity_feeds'
  spec.add_dependency 'carrierwave'
  spec.add_dependency 'rmagick' # needed for carrierwave resizing
end
