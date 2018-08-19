# frozen_string_literal: true

gh = 'https://github.com'
bb = 'https://bitbucket.org'

source ENV['GEM_SOURCE']

ruby ENV.fetch('RUBY_VERSION').sub('ruby-', '')

gem 'piktur',                   git:    "#{bb}/piktur/piktur.git",
                                branch: 'master'
gem 'piktur_security',          git:    "#{bb}/piktur/piktur_security.git",
                                branch: 'rails5'

gemspec

gem 'yard',                     git:    "#{gh}/lsegal/yard",
                                branch: 'master'

gem 'redcarpet'

group :test do
  gem 'piktur_spec',            git:     "#{bb}/piktur/piktur_spec.git",
                                branch:  'master'
end

group :production do
  gem 'newrelic_rpm'
end

# @note The following libraries SHOULD NOT be loaded, they are required here to ensure a
#   local copy of the source code is available to YARD.

gem 'gem_server',               git:     "#{bb}/piktur/gem_server.git",
                                branch:  'ebs',
                                require: false
gem 'piktur_stores',            git:     "#{bb}/piktur/piktur_stores.git",
                                branch:  'master',
                                require: false
gem 'piktur_core',              git:     "#{bb}/piktur/piktur_core.git",
                                branch:  'rom',
                                require: false
gem 'piktur_admin',             git:     "#{bb}/piktur/piktur_admin.git",
                                branch:  'webpack',
                                require: false
gem 'piktur_api',               git:     "#{bb}/piktur/piktur_api.git",
                                branch:  'trailblazer',
                                require: false
gem 'piktur_blog',              git:     "#{bb}/piktur/piktur_blog.git",
                                branch:  'master',
                                require: false
gem 'piktur_sites',             git:     "#{bb}/piktur/piktur_sites.git",
                                branch:  'master',
                                require: false
