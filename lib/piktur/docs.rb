# frozen_string_literal: true

require_relative '../../config/environment.rb'

require 'piktur'
require 'piktur/security'

module Piktur

  eager_load!

  self.container = Container.new

  Config.configure do |config|
    config.services = %w(piktur piktur_core piktur_security)
  end

  Security.install

  # @see https://bitbucket.org/piktur/piktur_core/issues/32 Git download example
  # @see https://bitbucket.org/snippets/piktur/84Bkj Piktur::Docs::App example
  # @see file:docs/config.ru
  #
  # @example Piktur API
  #   /v1/admin/token?auth[email]=*&auth[password]=*
  #
  module Docs

    # Return absolute path to docs directory
    # @return [Pathname]
    ROOT = Pathname.pwd.freeze

    # Return list of Piktur gem names
    # @return [Array<String>]
    GEMS = [
      *::Piktur.services&.names,
      'gem_server',
      'webpack'
    ].freeze

    # @note `--single-db` flag seems to break when frozen_string_literal enabled
    # @return [String]
    YARDOPTS = <<~SH.chomp
      --verbose
      --backtrace
      --debug
      --use-cache
      --no-private
      --embed-mixins
      --hide-void-return
      --markup-provider redcarpet
      --markup markdown
    SH

    FILES = <<~YAML.chomp
      lib/**/*.rb
      app/**/*.rb
      -
      README.markdown
    YAML

    # Polices access to Sidekiq::Web framework
    # @example
    #   entity = Admin.new
    #   Pundit.authorize(entity, :docs, :authorized?)
    class Policy < ::Policies::Base

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
    [:Admin].each { |const| ::Piktur::UserProxy.call(const, :admin) }

    class << self

      # @example Access gem info
      #   LibraryVersion#gemspec
      #   LibraryVersion#gemspec.version
      #
      # @see https://github.com/lsegal/yard/blob/master/lib/yard/server/library_version.rb
      #   YARD::Server::LibraryVersion
      #
      # @return [{String=>[YARD::Server::LibraryVersion]}]
      def libraries
        GEMS.each_with_object({}) do |lib, a|
          libver = ::YARD::Server::LibraryVersion.new(lib, nil, nil, :gem)
          a[lib] = [libver]
        end
      end

      private

        # Returns the path to the development directory
        #
        # @param [String] path
        #
        # @return [Pathname]
        def _local_source(path)
          existent = ::Dir["#{ENV['DEV_HOME']}/*/{piktur/#{path},gems/#{path},#{path}}"][0]
          Pathname(existent)
        end

    end

  end

end
