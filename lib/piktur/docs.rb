# frozen_string_literal: true

require_relative '../../config/environment.rb'
require_relative './docs/security.rb'

module Piktur

  # @see https://bitbucket.org/piktur/piktur_core/issues/32 Git download example
  # @see https://bitbucket.org/snippets/piktur/84Bkj Piktur::Docs::App example
  # @see file:docs/config.ru
  #
  # @example Piktur API
  #   /v1/admin/token?auth[email]=*&auth[password]=*
  #
  # @example Generate token from console
  #   Knock::AuthToken.new(payload: Admin.first.to_token_payload)
  #
  module Docs

    # Return absolute path to docs directory
    # @return [Pathname]
    ROOT = Pathname File.expand_path('../../', __dir__)

    # @return [Array]
    LIBRARIES = [
      'piktur_admin',
      'piktur_api',
      'piktur_blog',
      'piktur_client',
      'piktur_core',
      'piktur_store',
      'piktur'
    ]

    # @note frozen_string_literal seems to break this
    #   --single-db
    # @return [String]
    YARDOPTS = <<-EOS
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

    FILES = <<-EOS
lib/**/*.rb
app/**/*.rb
-
README.markdown
    EOS

    class << self

      # @example Access gem info
      #   LibraryVersion#gemspec
      #   LibraryVersion#gemspec.version
      # @see https://github.com/lsegal/yard/blob/master/lib/yard/server/library_version.rb
      #   YARD::Server::LibraryVersion
      # @return [{String=>[YARD::Server::LibraryVersion]}]
      def libraries
        LIBRARIES.each_with_object({}) do |lib, a|
          libver = YARD::Server::LibraryVersion.new(lib, nil, nil, :gem)
          a[lib] = [libver]
        end
      end

      private

        # Path to development directory
        # @param [String] path
        # @return [Pathname]
        def _local_source(path)
          Piktur.root.parent.join(path)
        end

        # @param [String] str
        # @return [String]
        def _namespace(str)
          str.classify
        end

    end

  end

end
