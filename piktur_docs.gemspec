# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('./lib', __dir__)

# Maintain your gem's version:
require 'piktur/docs/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'piktur_docs'
  s.version     = Piktur::Docs::VERSION
  s.authors     = ['Daniel Small']
  s.email       = ['piktur.io@gmail.com']
  s.homepage    = 'https://bitbucket.org/piktur/piktur_docs'
  s.summary     = 'Piktur a complete Portfolio Management System for Artists'
  s.description = 'Developer docs'
  s.license = ''
  s.files = Dir[
    'lib/**/*.rb',
    'app/**/*.rb',
    'config.ru',
    'README.markdown'
  ]
  s.test_files = Dir['spec/**/*']
  s.require_paths = %w(lib app)

  # @!group Piktur
  # @see Gemfile
  # s.add_dependency 'piktur_admin',                      '0.0.1'
  # s.add_dependency 'piktur_api',                        '0.0.1'
  # s.add_dependency 'piktur_blog',                       '0.0.1'
  # s.add_dependency 'piktur_client',                     '0.0.1'
  # s.add_dependency 'piktur_core',                       '0.0.1'
  # s.add_dependency 'piktur_store',                      '0.0.1'
  # s.add_dependency 'piktur',                            '0.0.1'
  # @!endgroup

  # @!group Framework
  s.add_dependency 'rack',                              '~> 1.6.5'
  # @!endgroup
end
