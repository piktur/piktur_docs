# frozen_string_literal: true

require_relative './lib/piktur/docs'

use Rack::Session::Cookie, secret: ENV.fetch('SECRET_KEY_BASE')

if ENV.fetch('RACK_ENV', 'development') == 'production'
  use(Rack::Auth::JWT, :Admin, domain: 'https://api.piktur.io/v1/token')
end

# @see https://github.com/lsegal/yard/blob/master/lib/yard/server/rack_middleware.rb
#   YARD::Server::RackMiddleware
run YARD::Server::RackAdapter.new(
  ::Piktur::Docs.libraries,
  { single_app: false, caching: false }, # YARD::Server::Adapter
  {}                                     # Rack::Server::Options
)
