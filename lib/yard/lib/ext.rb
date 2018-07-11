# frozen_string_literal: true

require 'yard'

module YARD

  module Tags

    class SchemaDirective < Directive

      def call
        return unless handler
        handler.extra_state.group = tag.text
      end

    end

    class EndSchemaDirective < Directive

      def call
        return unless handler
        handler.extra_state.group = nil
      end

    end

  end

  # @see https://github.com/theodorton/yard-activerecord
  # @see http://yardoc.org/guides/extending-yard/writing-handlers.html
  module Handlers

    module Ruby

      module Concerns; end

    end

  end

end

YARD::Templates::Engine.register_template_path File.join(__dir__, '/templates')

root = File.expand_path File.dirname(__FILE__)
$LOAD_PATH << root unless $LOAD_PATH.include? root

require_relative './handlers/ruby/concerns.rb'

YARD::Tags::Library.define_directive 'schema',    YARD::Tags::SchemaDirective
YARD::Tags::Library.define_directive 'endschema', YARD::Tags::EndSchemaDirective
