# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('./lib', __dir__)

require_relative './lib/piktur/docs/version.rb'

Gem::Specification.new do |s|
  s.name        = 'piktur_docs'
  s.version     = Piktur::Docs::VERSION
  s.authors     = ['Daniel Small']
  s.email       = ['piktur.io@gmail.com']
  s.homepage    = 'https://bitbucket.org/piktur/piktur_docs'
  s.summary     = 'Piktur a complete Portfolio Management System for Artists'
  s.description = 'Developer docs'
  s.license     = ''
  s.files       = Dir[
    '{config,lib}/**/*.rb',
    '.rubocop.yml',
    'config.ru',
    'piktur_docs.gemspec',
    'Procfile',
    'Rakefile',
    'README.markdown',
    base: __dir__
  ]
  s.test_files    = Dir['spec/**/*', base: __dir__]
  s.require_paths = %w(lib)

  # @!group Piktur
  # @see Gemfile
  # s.add_dependency 'piktur_admin',                      '0.0.1'
  # s.add_dependency 'piktur_api',                        '0.0.1'
  # s.add_dependency 'piktur_blog',                       '0.0.1'
  # s.add_dependency 'piktur_sites',                     '0.0.1'
  # s.add_dependency 'piktur_core',                       '0.0.1'
  # s.add_dependency 'piktur_stores',                      '0.0.1'
  # s.add_dependency 'piktur',                            '0.0.1'
  # @!endgroup

  s.add_dependency 'rack', '~> 2.0'

  s.add_development_dependency 'pry', '~> 0.10'
end
