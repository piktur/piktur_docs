# frozen_string_literal: true

require_relative '../../config/environment.rb'
require 'piktur'

module Piktur

  # @see https://bitbucket.org/piktur/piktur_core/issues/32 Git download example
  # @see https://bitbucket.org/snippets/piktur/84Bkj Piktur::Docs::App example
  # @see file:docs/config.ru
  #
  # @example Piktur API
  #   /v1/admin/token?auth[email]=*&auth[password]=*
  #
  # @example Generate token from console
  #   Piktur::Security::JWT::Token.new(payload: User::Admin.first.to_jwt_claims)
  #
  module Docs

    ::Piktur.configure do |c|
      c.services = nil
      c.finalize!
    end

    # Return absolute path to docs directory
    # @return [Pathname]
    ROOT = Pathname(File.expand_path('../../', __dir__)).freeze

    # Return list of Piktur gem names
    # @return [Array<String>]
    GEMS = [
      *Piktur.config.services.names,
      'gem_server',
      'webpack'
    ].freeze

    # @note `--single-db` flag seems to break when frozen_string_literal enabled
    # @return [String]
    YARDOPTS = <<~EOS.chomp
      --verbose
      --backtrace
      --debug
      --use-cache
      --no-private
      --embed-mixins
      --hide-void-return
      --markup-provider redcarpet
      --markup markdown
    EOS

    FILES = <<~EOS.chomp
      lib/**/*.rb
      app/**/*.rb
      -
      README.markdown
    EOS

    # Polices access to Sidekiq::Web framework
    # @example
    #   entity = Admin.new
    #   Pundit.authorize(entity, :docs, :authorized?)
    class DocsPolicy < Piktur::BasePolicy

      # @return [Boolean]
      def authorized?
        admin?
      end

    end

    # Setup `UseProxy` for permitted entities. The proxy object supports authentication without a
    # database connection.
    #
    # To **authenticate** include **JSON Web Token (JWT)** via
    #   * url    `?token=<token>`
    #   * header `Authorization: Bearer <token>`
    [:Admin].each { |const| ::Piktur::UserProxy.call(const) }

    class << self

      # @example Access gem info
      #   LibraryVersion#gemspec
      #   LibraryVersion#gemspec.version
      # @see https://github.com/lsegal/yard/blob/master/lib/yard/server/library_version.rb
      #   YARD::Server::LibraryVersion
      # @return [{String=>[YARD::Server::LibraryVersion]}]
      def libraries
        GEMS.each_with_object({}) do |lib, a|
          libver = ::YARD::Server::LibraryVersion.new(lib, nil, nil, :gem)
          a[lib] = [libver]
        end
      end

      private

        # Path to development directory
        # @param [String] path
        # @return [Pathname]
        def _local_source(path)
          Pathname(::Dir["#{ENV['DEV_HOME']}/*/{piktur/#{path},gems/#{path},#{path}}"][0])
        end

    end

  end

end
