# frozen_string_literal: true

require 'rubygems'
require 'bundler'

Bundler.setup
Bundler.require :default, (ENV['RACK_ENV'] ||= 'development')

# Set common ENV variables
require 'piktur/env'

require 'active_support/core_ext/string/inflections'
require 'yard'
# @example Load yard doc extensions. Transfered equivalent behaviour to `/.yardopts`
#   require_relative './piktur_core/lib/yard/ext.rb'
require 'redcarpet'
require 'rack/auth/jwt'

require_relative '../../app/policies/docs_policy'

module Piktur

  # @note Run `rake yard:prepare` after deploy to fetch remote source.
  #
  # @see https://github.com/lsegal/yard/blob/master/lib/yard/registry.rb YARD::Registry
  #
  # @see https://github.com/lsegal/yard/blob/master/lib/yard/server/library_version.rb
  #   YARD::Server::LibraryVersion
  #
  # @see https://github.com/lsegal/yard/blob/master/lib/yard/server/rack_middleware.rb
  #   YARD::Server::RackMiddleware
  #
  # @see https://bitbucket.org/snippets/piktur/84Bkj Piktur::Docs::App example
  #
  # @see file:docs/config.ru
  #
  # @example Piktur API
  #   api/v1/token?auth[email]=*&auth[password]=*
  #
  # @example Generate token from console
  #   Knock::AuthToken.new(payload: Admin.first.to_token_payload)
  #
  # @example Caching strategy
  #   def self.cache
  #     @cache ||= ActiveSupport::Cache.lookup_store(:memory_store)
  #   end
  #
  #   def render(object = nil)
  #     cache do
  #       case object
  #       when CodeObjects::Base
  #         object.format(options)
  #       when nil
  #         Templates::Engine.render(options)
  #       else
  #         object
  #       end
  #     end
  #   end
  #
  #   # Override this method to implement custom caching mechanisms for
  #   #
  #   # @example Caching to memory
  #   #   $memory_cache = {}
  #   #   def cache(data)
  #   #     $memory_cache[path] = data
  #   #   end
  #   # @param [String] data the data to cache
  #   # @return [String] the same cached data (for chaining)
  #   # @see StaticCaching
  #   def cache(data = nil, &block)
  #     self.body = if caching && block
  #       self.class.cache.fetch(request.path_info) { yield block }
  #     else
  #       data
  #       # key = Digest::MD5.hexdigest(data.to_s)
  #       # self.class.cache.fetch(key) { data }
  #     end
  #   end
  module Docs

    class << self

      # Return absolute path to docs directory
      # @return [Pathname]
      def root
        @root ||= Pathname.new File.expand_path('../../', __dir__)
      end

      # @todo Document remaining libraries
      #   piktur
      #   blog
      #   client
      #   admin
      #   store
      # @return [Array]
      def names
        @names ||= %w(
          core
          api
        )
      end

      # @example Can objects be shared across libraries?
      #   @return [Array<String>]
      #   def self.registries
      #     @docs = []
      #   end
      #
      #   def self.load
      #     YARD::Registry.load(docs, true)
      #   end
      #
      #   registries << yardoc
      #
      # @example Add version tag
      #   libver = YARD::Server::LibraryVersion.new(dir_name, version, yardoc, :disk)
      #
      # @return [Hash{String=>[YARD::Server::LibraryVersion]}]
      def libraries
        names.each_with_object({}) do |lib, a|
          dir_name  = _prefix(lib)
          docs_path = root.join(dir_name)
          yardoc    = docs_path.join('.yardoc').to_s
          # local_source = _local_source(dir_name)

          libver = YARD::Server::LibraryVersion.new(dir_name, nil, yardoc, :disk)
          libver.source      = docs_path.to_s # local_source.to_s
          libver.source_path = docs_path.to_s # local_source.to_s
          # "#{_namespace(lib)} [#{dir_name}]"
          a[dir_name] = [libver]
        end
      end

      # Fetch remote source
      # @return [void]
      def prepare
        msg   = ->(repo, res) { puts "Fetching #{res} from #{_repo_uri(repo)}" }
        fname = 'README.markdown'

        names.each do |lib|
          repo_name     = _prefix(lib)
          remote_source = _repo_uri(repo_name, true)

          msg.call repo_name, fname
          _get_file remote_source, fname, repo_name

          msg.call repo_name, 'archive'
          _get_archive remote_source, repo_name
        end
      end

      protected

        # @param [String] repo
        # @param [Boolean] auth Include credentials
        # @return [String]
        def _repo_uri(repo, auth = false)
          [
            'https://',
            ("#{ENV['BUNDLE_BITBUCKET__ORG']}@" if auth),
            "bitbucket.org/#{ENV['BITBUCKET_USER']}/#{repo}"
          ].join
        end

        # Fetch `file` from `origin` and save to `dest`
        # @param [String] origin
        # @param [String] file
        # @param [String] dest
        # @return [void]
        def _get_file(origin, file, dest)
          `curl #{origin}/raw/master/#{file} -o #{dest}/#{file}`
        end

        # Fetch master from `origin` and extract contents to 'src'
        # @param [String] origin
        # @param [String] dest
        # @return [void]
        def _get_archive(origin, dest)
          Dir.chdir(dest) do
            `curl #{origin}/get/master.tar.gz -o master.tar.gz`
            `tar -zxf master.tar.gz`
            File.rename Dir["piktur-#{dest}*"][0], 'src'
          end
        end

      private

        # @param [String] lib
        # @return [String]
        def _prefix(lib)
          lib == 'piktur' ? lib : "piktur_#{lib}"
        end

        # Path to development directory
        # @param [String] dir
        # @return [Pathname]
        def _local_source(dir)
          Piktur.root.parent.join(dir)
        end

        # Extract version tag
        # @param [String] lib
        # @return [String]
        def _version(lib)
          path = if lib == 'piktur'
                   # Piktur.root.parent.join('lib/piktur/version.rb')
                   root.join(lib, 'src/lib/piktur/version.rb')
                 else
                   # Piktur.root.parent.join("lib/piktur/#{lib}/version.rb")
                   root.join(lib, "src/lib/piktur/#{lib}/version.rb")
                 end

          # require_relative path

          # const = "#{_namespace(lib)}::VERSION"
          # Object.const_defined?(const) && Object.const_get(const)

          # /VERSION\s?=\s?'(.*)'/
          regex = /(\d\.\d\.\d)/
          File.read(path).match(regex)[1]
        end

        # @param [String] lib
        # @return [String]
        def _namespace(lib)
          if lib == 'piktur'
            'Piktur'
          else
            "Piktur::#{lib.classify}"
          end
        end

    end

  end

end
