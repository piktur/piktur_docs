# frozen_string_literal: true

gh = 'https://github.com'
bb = 'https://bitbucket.org'

# source 'https://rubygems.org'
source ENV['GEM_SOURCE']

ruby '2.3.0'

gemspec name: 'piktur_docs'

# @note Bundler will load all matching `{,*,*/*}.gemspec`. Due to local directory structure
#   `../piktur_admin.gemspec`, `../piktur_store.gemspec` etc. are parsed when running `bundle
#   install` on the local dev machine. You may want to override `glob: '*.gemspec'` to avoid this.

gem 'piktur',                   git:    "#{bb}/piktur/piktur.git",
                                branch: 'master'

gem 'yard',                     git:    "#{gh}/lsegal/yard",
                                branch: 'master'

gem 'redcarpet'

group :production do
  gem 'newrelic_rpm'
end

# @note The following libraries SHOULD NOT be loaded, they are required here to ensure a
#   local copy of the source code is available to YARD.

gem 'gem_server',               git:     "#{bb}/piktur/gem_server.git",
                                branch:  'ebs',
                                require: false

gem 'piktur_admin',             git:     "#{bb}/piktur/piktur_admin.git",
                                branch:  'webpack',
                                require: false
gem 'piktur_api',               git:     "#{bb}/piktur/piktur_api.git",
                                branch:  'develop',
                                require: false
# gem 'piktur_blog',              git:     "#{bb}/piktur/piktur_blog.git",
#                                 branch:  'master',
#                                 require: false
# gem 'piktur_client',            git:     "#{bb}/piktur/piktur_client.git",
#                                 branch:  'master',
#                                 require: false
gem 'piktur_core',              git:     "#{bb}/piktur/piktur_core.git",
                                branch:  'json',
                                require: false
gem 'piktur_store',             git:     "#{bb}/piktur/piktur_store.git",
                                branch:  'master',
                                require: false
