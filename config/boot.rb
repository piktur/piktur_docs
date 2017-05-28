# frozen_string_literal: true

ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __dir__)
ENV['RACK_ENV']       ||= 'development'

require 'rubygems'
require 'bundler/setup' # Set up gems listed in the Gemfile.

Bundler.require(:default, ENV['RACK_ENV'])
