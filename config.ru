# frozen_string_literal: true

require_relative './lib/piktur/docs'

use Rack::Session::Cookie, secret: ENV['SECRET_KEY_BASE']

use Rack::Auth::JWT, :Admin, domain: 'https://api.piktur.io/v1/token'

# @example
#   # Build documentation for Piktur libraries locally with:
#   rake yard:api
#   rake yard:core
#   # ...
#
#   # Start server
#   RACK_ENV=development rackup
run YARD::Server::RackAdapter.new ::Piktur::Docs.libraries, single_app: false, caching: true
