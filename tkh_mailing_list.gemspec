# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tkh_mailing_list/version'

Gem::Specification.new do |spec|
  spec.name          = "tkh_mailing_list"
  spec.version       = TkhMailingList::VERSION
  spec.authors       = ["Swami Atma"]
  spec.email         = ["swami@TenThousandHours.eu"]
  spec.description   = %q{A mailing list module to work with tkh_authentication gem}
  spec.summary       = %q{This gem inherits from the tkh_authentication gem and allow administrators to manage user records}
  spec.homepage      = "https://github.com/allesklar/tkh_mailing_list"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"

  spec.add_dependency "tkh_authentication", '~> 0.1.8'
end
