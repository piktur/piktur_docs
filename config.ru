# frozen_string_literal: true

require_relative './lib/piktur/docs'

use Rack::Session::Cookie, secret: ENV['SECRET_KEY_BASE']

use Rack::Auth::JWT, :Admin, domain: 'https://api.piktur.io/v1/token' unless
  ENV['RACK_ENV'] == 'development'

# @see https://github.com/lsegal/yard/blob/master/lib/yard/server/rack_middleware.rb
#   YARD::Server::RackMiddleware
run YARD::Server::RackAdapter.new(
  ::Piktur::Docs.libraries,
  { single_app: false, caching: false }, # YARD::Server::Adapter
  {}                                     # Rack::Server::Options
)
