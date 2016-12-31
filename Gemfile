# frozen_string_literal: true

gh = 'https://github.com'
bb = 'https://bitbucket.org'

# source 'https://rubygems.org'
source ENV['GEM_SOURCE']

ruby '2.3.0'

gemspec name: 'piktur_docs'

# @!group Piktur
# @note Bundler will load all matching `{,*,*/*}.gemspec`. Due to local directory structure
#   `../piktur_admin.gemspec`, `../piktur_store.gemspec` etc. are parsed when running `bundle
#   install` on the local dev machine. You may want to override `glob: '*.gemspec'` to avoid this.
gem 'piktur',                   git:    "#{bb}/piktur/piktur.git",
                                branch: 'master'
# @!endgroup

group :production do
  gem 'newrelic_rpm'
end
